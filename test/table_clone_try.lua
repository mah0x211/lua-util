local typeof = require('util.typeof');
local clone = require('util.table').clone;
local cloneSafe = require('util.table').cloneSafe;
-- types
local data = {
    -- boolean
    { val = true },
    { val = false },
    { [true] = true },
    { [false] = false },
    -- string
    { val = 'hello' },
    { ['hello'] = 'hello' },
    -- number
    { val = 0 },
    { val = 1 },
    { val = -1 },
    { val = 0.1 },
    { val = 1/0 },
    { val = 0/0 },
    { [0] = 0 },
    { [1] = 1 },
    { [-1] = -1 },
    { [0.1] = 0.1 },
    { [1/0] = 1/0 },
    -- function
    { val = function()end },
    { [function()end] = function()end },
    -- table
    { val = {} },
    { [{}] = {} },
    -- thread
    { val = coroutine.create(function() end) },
    { [coroutine.create(function() end)] = coroutine.create(function() end) }
};
local tbl;

-- clone
tbl = ifNil( clone( data ) );

local function verify( a, b )
    ifEqual( tostring(a), tostring( b ) );
    
    for k, v in pairs( a, b ) do
        if typeof.table( v ) then
            verify( v, b[k] );
        -- nan
        elseif v ~= v then
            ifNotTrue( b[k] ~= b[k] );
        else
            ifNotEqual( v, b[k] );
        end
    end
end
verify( data, tbl );

-- copySafe
tbl = ifNil( cloneSafe( data ) );
local SAFE_VAL_TYPES = {
    ['string'] = 1,
    ['number'] = 1,
    ['boolean'] = 1
};
local function verifySafe( a, b )
    local t;
    
    -- should not be equal table
    ifEqual( tostring(a), tostring( b ) );
    
    for k, v in pairs( a, b ) do
        -- key must be string or unsigned integer
        if typeof.string( k ) or typeof.uint( k ) then
            t = type( v );
            if t == 'table' then
                verifySafe( v, b[k] );
            -- primitive val must be string, number or boolean
            elseif SAFE_VAL_TYPES[t] then
                -- nan
                if v ~= v then
                    ifNotTrue( b[k] ~= b[k] );
                else
                    ifNotEqual( v, b[k] );
                end
            else
                ifNotNil( b[k] );
            end
        else
            ifNotNil( b[k] );
        end
    end
end
verifySafe( data, tbl );

