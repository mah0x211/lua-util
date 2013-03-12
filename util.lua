local function inspect( obj, indent )
    local res = {};
    local t = type( obj );
    
    indent = indent or '';
    
    if t == 'table' then
        local k,v = next( obj );
        local LF = '';
        table.insert( res, '{ ' );
        while k do
            LF = '\n';
            t = type( v );
            table.insert( res, '\n' .. indent .. 
                          '    "' .. tostring( k ) .. '"' );
            if t == 'table' then
                table.insert( res, ': ' .. inspect( v, indent .. '    ' ) );
            elseif t == 'string' then
                table.insert( res, ': "' .. v .. '",' );
            elseif t == 'number' then
                table.insert( res, ': ' .. tostring( v ) .. ',' );
            else
                table.insert( res, ': "' .. tostring( v ) .. '",' );
            end
            -- next item
            k,v = next( obj,k );
        end
        table.insert( res, LF .. indent .. '},' );
    elseif t == 'string' then
        table.insert( res, indent .. obj .. ',' );
    else
        table.insert( res, indent .. tostring( obj ) .. ',' );
    end
    
    return table.concat( res, '' );
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

local function join( arr, sep )
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


local function eperm( tbl, key, val )
    error( "Cannot add/modify property '" .. key ..  "' of read-only table." ..
            " <" .. tostring(tbl) .. ">", 2 );
end

local function _freeze( tbl, act )
    return setmetatable( {}, {
        __index = tbl,
        __newindex = act or eperm
    })
end

local function freeze( tbl, all, act )
    if all == true then
        local res = {};
        local k,v = next( tbl );
        local t;
        while k do
            t = type( v );
            if t == 'table' then
                rawset( res, k, freeze( v, all, act ) );
            else
                rawset( res, k, v );
            end
            k,v = next( tbl, k );
        end
        return _freeze( res, act );
    else
        return _freeze( tbl, act );
    end
end

return {
    freeze = freeze,
    concat = concat,
    join = join,
    inspect = inspect
};
