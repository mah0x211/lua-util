local typeof = require('util.typeof');

-- types
local data = {
    -- nil
    {   ['nil']     = true,
        ['non']     = true },

    -- boolean
    {   val         = true,
        ['boolean'] = true },
    {   val         = false,
        ['boolean'] = true,
        ['non']     = true },

    -- string
    {   val         = 'hello',
        ['string']  = true },
    {   val         = 'world',
        ['string']  = true },
    {   val         = '',
        ['string']  = true,
        ['non']     = true },

    -- number
    {   val         = 0,
        ['number']  = true,
        ['finite']  = true,
        ['unsigned']= true,
        ['int']     = true,
        ['uint']    = true,
        ['non']     = true },
    {   val         = 1,
        ['number']  = true,
        ['finite']  = true,
        ['unsigned']= true,
        ['int']     = true,
        ['uint']    = true },
    {   val         = -1,
        ['number']  = true,
        ['finite']  = true,
        ['int']     = true },
    {   val         = 0.1,
        ['number']  = true,
        ['finite']  = true,
        ['unsigned']= true },
    {   val         = -0.1,
        ['number']  = true,
        ['finite']  = true },
    {   val         = 1/0,
        ['number']  = true },
    {   val         = 0/0,
        ['number']  = true,
        ['nan']     = true,
        ['non']     = true },
    
    -- function
    {   val         = function()end,
        ['function']= true },
    
    -- table
    {   val         = {},
        ['table']   = true },
    
    -- thread
    {   val         = coroutine.create(function() end),
        ['thread']  = true }
};
local nilVal;

for _, method in ipairs({
    'nil', 'table', 'function', 'thread', 'userdata', 'boolean', 'string', 
    'number', 'finite', 'unsigned', 'int', 'uint', 'nan', 'non'
}) do
    print( ('\n<%s>'):format( method ) );

    for _, field in ipairs( data ) do 
        res = typeof[method]( field.val );
        cmp = field[method] == true;
        print( _, 
            ('%21s %3s %s -> %s'):format( 
                tostring(field.val), 
                cmp and 'is' or 'not',
                method, 
                tostring(res)
            )
        );
        assert( res == cmp );
    end
end
