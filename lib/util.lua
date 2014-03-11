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
            
            rawset( circular, ref, nil );
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


return {
    inspect = inspect,
    ['typeof'] = require('util.typeof'),
    ['string'] = require('util.string'),
    ['table'] = require('util.table')
};
