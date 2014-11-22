local typeof = require('util.typeof');

-- types
local data = {
    -- nil
    {   chk = {
            ['nil']     = true,
            ['non']     = true 
        }
    },

    -- boolean
    {   val = true,
        chk = {
            ['boolean'] = true 
        }
    },
    {   val = false,
        chk = {
            ['boolean'] = true,
            ['non']     = true 
        }
    },

    -- string
    {   val = 'hello',
        chk = {
            ['string']  = true 
        }
    },
    {   val = 'world',
        chk = {
            ['string']  = true 
        }
    },
    {   val = '',
        chk = {
            ['string']  = true,
            ['non']     = true 
        }
    },

    -- number
    {   val = 0,
        chk = {
            ['number']  = true,
            ['finite']  = true,
            ['unsigned']= true,
            ['int']     = true,
            ['uint']    = true,
            ['non']     = true 
        }
    },
    {   val = 1,
        chk = {
            ['number']  = true,
            ['finite']  = true,
            ['unsigned']= true,
            ['int']     = true,
            ['uint']    = true 
        }
    },
    {   val = -1,
        chk = {
            ['number']  = true,
            ['finite']  = true,
            ['int']     = true 
        }
    },
    {   val = 0.1,
        chk = {
            ['number']  = true,
            ['finite']  = true,
            ['unsigned']= true 
        }
    },
    {   val = -0.1,
        chk = {
            ['number']  = true,
            ['finite']  = true 
        }
    },
    {   val = 1/0,
        chk = {
            ['number']  = true 
        }
    },
    {   val = 0/0,
        chk = {
            ['number']  = true,
            ['nan']     = true,
            ['non']     = true 
        }
    },
    
    -- integer
    {   val = -128,
        chk = {
            ['int8']    = true,
            ['int16']   = true,
            ['int32']   = true 
        }
    },
    {   val = 127,
        chk = {
            ['int8']    = true,
            ['int16']   = true,
            ['int32']   = true 
        }
    },
    {   val = -32768,
        chk = {
            ['int8']    = false,
            ['int16']   = true,
            ['int32']   = true 
        }
    },
    {   val = 32767,
        chk = {
            ['int8']    = false,
            ['int16']   = true,
            ['int32']   = true 
        }
    },
    {   val = -2147483648,
        chk = {
            ['int8']    = false,
            ['int16']   = false,
            ['int32']   = true 
        }
    },
    {   val = 2147483647,
        chk = {
            ['int8']    = false,
            ['int16']   = false,
            ['int32']   = true 
        }
    },
    -- unsigned integer
    {   val = 255,
        chk = {
            ['uint8']    = true,
            ['uint16']   = true,
            ['uint32']   = true 
        }
    },
    {   val = 65535,
        chk = {
            ['uint8']    = false,
            ['uint16']   = true,
            ['uint32']   = true 
        }
    },
    {   val = 4294967295,
        chk = {
            ['uint8']    = false,
            ['uint16']   = false,
            ['uint32']   = true 
        }
    },
    
    -- function
    {   val = function()end,
        chk = {
            ['Function']= true 
        }
    },
    
    -- table
    {   val = {},
        chk = {
            ['table']   = true 
        }
    },
    
    -- thread
    {   val = coroutine.create(function() end),
        chk = {
            ['thread']  = true 
        }
    }
};
local nilVal;
local msg;

for _, field in ipairs( data ) do 
    for method, res in pairs( field.chk ) do
        msg = ('typeof.%s( %s ) == %s'):format( 
            method, tostring( field.val ), tostring( res )
        );
        ifNotEqual( typeof[method]( field.val ), res, msg );
    end
end
