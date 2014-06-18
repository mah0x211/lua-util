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

local LUA_FIELDNAME_PAT = '^[a-zA-Z_][a-zA-Z0-9_]*$';
local FOR_INDEX = 'index';
local FOR_VALUE = 'value';
local FOR_CIRCULAR = 'circular';
-- default indentaion
local INDENT_LV = 4;
local RESERVED_WORD = {
    -- primitive data
    ['nil']         = true,
    ['true']        = true,
    ['false']       = true,
    -- declaraton
    ['local']       = true,
    ['function']    = true,
    -- boolean logic
    ['and']         = true,
    ['or']          = true,
    ['not']         = true,
    -- conditional statement
    ['if']          = true,
    ['elseif']      = true,
    ['else']        = true,
    -- iteration statement
    ['for']         = true,
    ['in']          = true,
    ['while']       = true,
    ['until']       = true,
    ['repeat']      = true,
    -- jump statement
    ['break']       = true,
    ['goto']        = true,
    ['return']      = true,
    -- block scope statement
    ['then']        = true,
    ['do']          = true,
    ['end']         = true
};

local function defaultCallback( value, valueType, valueFor, key, udata )
    return value;
end


local function _inspect( obj, indent, nestIndent, tail, ctx )
    local ref = tostring( obj );
    local val;
    
    -- circular reference
    if not ctx.circular[ref] then
        local res = {};
        local k,v = next( obj );
        local nestTail = '';
        local t, skip, raw;
        
        -- save reference
        rawset( ctx.circular, ref, true );
        -- set head and tail bracket
        table.insert( res, '{ ' );
        tail = ( k and '\n' .. indent or '' ) .. '}';
        
        while k do
            -- key
            val, skip = ctx.callback( k, type( k ), FOR_INDEX, nil, ctx.udata );
            k = val or k;
            if not skip then
                t = type( k );
                -- hash index
                -- array index
                if t == 'number' then
                    table.insert( res, 
                        nestTail .. '\n' .. indent .. nestIndent .. 
                        '['.. k ..'] = '
                    );
                -- standard name
                elseif t == 'string' and not RESERVED_WORD[k] and
                       k:match( LUA_FIELDNAME_PAT ) then
                    table.insert( res, 
                        nestTail .. '\n' .. indent .. nestIndent .. k .. ' = ' 
                    );
                -- add bracket
                else
                    table.insert( res, 
                        nestTail .. '\n' .. indent .. nestIndent ..
                        '["' .. tostring( k ) .. '"] = ' );
                end
                
                -- value
                val, raw = ctx.callback( v, type( v ), FOR_VALUE, k, ctx.udata );
                v = val or v;
                t = type( v );
                -- raw value
                if raw then
                    table.insert( res, v );
                elseif t == 'table' then
                    table.insert( res, 
                        _inspect( v, indent .. nestIndent, nestIndent, ',', ctx )
                    );
                elseif t == 'string' then
                    table.insert( res, string.format( '%q', v ) );
                elseif t == 'number' or t == 'boolean' then
                    table.insert( res, tostring(v) );
                else
                    table.insert( res, string.format( '%q', tostring( v ) ) );
                end
            end
                
            -- next item
            k,v = next( obj, k );
            nestTail = ',';
        end
        
        -- remove reference
        rawset( ctx.circular, ref, nil );
        -- append tail
        table.insert( res, tail );
        
        return table.concat( res, '' );
    end
    
    val = ctx.callback( obj, type( obj ), FOR_CIRCULAR, obj, ctx.udata );
    return type( val ) == 'table' and '"<Circular ' .. ref .. '>"' or val;
end


local function inspect( obj, opt )
    local t = type( obj );
    
    if t == 'table' then
        local indent = ('%'.. ( opt and opt.depth or INDENT_LV ) ..'s'):format('');
        local padding = ('%'.. ( opt and opt.padding or 0 ) ..'s'):format('');
        
        return _inspect( obj, padding, indent, '', {
            circular = {},
            callback = opt and opt.callback or defaultCallback,
            udata = opt and opt.udata or nil
        });
    end
    
    return opt and opt.callback( obj, t, FOR_VALUE, false ) or tostring( obj );
end


return {
    inspect = inspect,
    ['typeof'] = require('util.typeof'),
    ['string'] = require('util.string'),
    ['table'] = require('util.table')
};
