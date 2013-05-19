--[[

  Copyright (C) 2013 Masatoshi Teruya
 
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
 
  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.
 
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.

--]]

local function _inspect( obj, indent, nestIndent, tail, circular )
    local res = {};
    local t = type( obj );
    
    if t == 'table' then
        local k,v = next( obj );
        local nestTail = '';
        local ref = tostring( obj );
        local tk;
        
        -- circular reference
        if circular[ref] then
            table.insert( res, '"<Circular ' .. ref .. '>"' );
        else
            -- save reference
            rawset( circular, ref, true );
            table.insert( res, '{ ' );
            tail = ( k and '\n' .. indent or '' ) .. '}';
            
            while k do
                tk = type( k );
                if tk == 'string' then
                    -- if standard name rule
                    if string.match( k, '^[a-zA-Z_][a-zA-Z0-9_]*$' ) then
                        table.insert( res, nestTail .. '\n' .. indent .. 
                                      nestIndent .. k .. ' = ' );
                    -- add bracket
                    else
                        table.insert( res, nestTail .. '\n' .. indent .. 
                                      nestIndent ..'["' .. k .. '"] = ' );
                    end
                elseif tk == 'number' then
                    table.insert( res, nestTail .. '\n' .. indent .. nestIndent );
                else
                    table.insert( res, nestTail .. '\n' .. indent .. nestIndent ..
                                  '["' .. tostring( k ) .. '"]' );
                end
                
                t = type( v );
                if t == 'table' then
                    table.insert( res, _inspect( v, indent .. nestIndent, nestIndent, ',', circular ) );
                elseif t == 'string' then
                    table.insert( res, '"' .. v .. '"' );
                elseif t == 'number' then
                    table.insert( res, tostring( v ) );
                else
                    table.insert( res, '"' .. tostring( v ) .. '"' );
                end
                
                -- next item
                k,v = next( obj,k );
                nestTail = ',';
            end
            
            table.insert( res, tail );
        end
    elseif t == 'string' then
        table.insert( res, indent .. obj .. tail );
    else
        table.insert( res, indent .. tostring( obj ) .. tail );
    end
    
    return table.concat( res, '' );
end

local function inspect( obj, indent_lv )
    local indent = '';
    local i = 0;
    
    indent_lv = indent_lv or 4;
    for i = 0, indent_lv - 1, 1 do
        indent = indent .. ' ';
    end
    
    return _inspect( obj, '', indent, '', {} );
end



local function eperm( tbl, key, val )
    error( "Cannot add/modify property '" .. key ..  "' of read-only table." ..
            " <" .. tostring(tbl) .. ">", 2 );
end

local function _tbl_freezing( tbl, act )
    return setmetatable( {}, {
        __index = tbl,
        __newindex = act or eperm
    })
end

local function _tbl_freeze( tbl, all, act, circular )
    if all == true then
        local res = {};
        local k,v = next( tbl );
        local t,ref;
        while k do
            t = type( v );
            if t == 'table' then
                ref = tostring( v );
                if circular[ref] == nil then
                    circular[ref] = true;
                    rawset( res, k, _tbl_freeze( v, all, act, circular ) );
                end
            else
                rawset( res, k, v );
            end
            k,v = next( tbl, k );
        end
        
        return _tbl_freezing( res, act );
    end
    
    return _tbl_freezing( tbl, act );
end

local function tbl_freeze( tbl, all, act )
    return _tbl_freeze( tbl, all, act, {} );
end


local function tbl_getkv( tbl, ... )
    local argv = {...};
    local argc = #argv;
    local val,i;
    
    for i = 1, argc - 1, 1 do
        val = tbl[argv[i]];
        if type( val ) ~= 'table' then
            return nil;
        end
        tbl = val;
    end
    
    return tbl[argv[argc]];
end


local function tbl_setkv( tbl, ... )
    local argv = {...};
    local argc = #argv;
    local prev = tbl;
    local val;
    
    for i = 1, argc - 1, 1 do
        val = prev[argv[i]];
        if type( val ) ~= 'table' then
            for i = i, argc - 1, 1 do
                val = {};
                prev[argv[i]] = val;
                prev = val;
            end
            break;
        end
        prev = val;
    end
    
    prev[argc] = argv[argc];
    
    return prev;
end


local function tbl_keys( tbl )
    local list = {};
    for k in pairs( tbl ) do
        table.insert( list, k );
    end
    return list;
end


local function tbl_each( tbl, fn )
    local k,v = next( tbl );
    
    while k do
        if fn( v, k, tbl ) == false then
            break;
        end
        k,v = next( tbl, k );
    end
end


local function tbl_each_key( tbl, fn )
    for k,v in pairs( tbl ) do
        if fn( v, k, tbl ) == false then
            break;
        end
    end
end


local function tbl_each_idx( tbl, fn )
    for i,v in ipairs( tbl ) do
        if fn( v, i, tbl ) == false then
            break;
        end
    end
end


local function tbl_merge( src, dest, idx )
    local k,v = next( src );
    
    if type( idx ) == 'number' then
        while k do
            table.insert( dest, idx, v );
            idx = idx + 1;
            k,v = next( src, k );
        end
    else
        while k do
            table.insert( dest, v );
            k,v = next( src, k );
        end
    end
end


local function tbl_join( arr, sep )
    local res = {};
    local k,v = next( arr );
    local tk,tv;
    -- traverse table as array
    while k do
        t = type( v );
        if t == 'string' or t == 'number' then
            table.insert( res, v );
        else
            table.insert( res, tostring( v ) );
        end
        k,v = next( arr, k );
    end
    
    return table.concat( res, sep );
end


local function str_split( str, sep )
    local res = {};
    
    for seg in string.gmatch( str, '[^' .. sep .. ']+' ) do
        table.insert( res, seg );
    end
    
    return res;
end


local function concat( ... )
    local res = {};
    local args = {...};
    local idx,arg = next( args );
    local k,v,t;
    -- traverse arguments
    while idx do
        t = type( arg );
        -- traverse table
        if t == 'table' then
            k,v = next( arg );
            while k do
                t = type( k );
                -- indexed value
                if t == 'number' then
                    table.insert( res, v );
                -- keyed value
                else
                    rawset( res, k, v );
                end
                k,v = next( arg, k );
            end
        -- add arg
        else
            table.insert( res, arg );
        end
        idx,arg = next( args, idx );
    end
    
    return res;
end


local function _isa( ist, ... )
    local argv = {...};
    local argc = #argv;
    local t = type( argv[1] );
    
    if argc < 2 then
        return t == ist;
    elseif t == 'table' then
        local arg = str_split( argv[2], '.' );
        -- fn.apply( this, args );
        table.insert( arg, 1, argv[1] );
        arg = tbl_getkv( unpack( arg ) );
        if type( arg ) ~= ist then
            return false;
        end
        
        return argc < 3 or arg == argv[3];
    end
    
    return t == ist and argv[1] == argv[2];
end

local function is_bool( ... )
    return _isa( 'boolean', ... );
end

local function is_str( ... )
    return _isa( 'string', ... );
end

local function is_num( ... )
    return _isa( 'number', ... );
end

local function is_func( ... )
    return _isa( 'function', ... );
end

local function is_tbl( ... )
    return _isa( 'table', ... );
end

local function is_thd( ... )
    return _isa( 'thread', ... );
end

local function is_udata( ... )
    return _isa( 'userdata', ... );
end


return {
    freeze = tbl_freeze,
    getkv = tbl_getkv,
    setkv = tbl_setkv,
    keys = tbl_keys,
    each = tbl_each,
    each_key = tbl_each_key,
    each_idx = tbl_each_idx,
    merge = tbl_merge,
    join = tbl_join,
    split = str_split,
    concat = concat,
    is_bool = is_bool,
    is_str = is_str,
    is_num = is_num,
    is_func = is_func,
    is_tbl = is_tbl,
    is_thd = is_thd,
    is_udata = is_udata,
    inspect = inspect
};
