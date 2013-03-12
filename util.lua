function inspect( self, obj, indent )
    local res = {};
    local t = type( obj );
    
    indent = indent or '';
    
    if t == 'table' then
        -- first item
        local k,v = next( obj );
        local LF = '';
        table.insert( res, '{ ' );
        while k do
            LF = '\n';
            t = type( v );
            table.insert( res, '\n' .. indent .. 
                          '    "' .. tostring( k ) .. '"' );
            if t == 'table' then
                table.insert( res, ': ' .. self:inspect( v, indent .. '    ' ) );
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

return {
    inspect = inspect
};
