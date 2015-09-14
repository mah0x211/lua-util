local is = require('util.is');
-- types
local data = {
    -- nil
    {   chk = {
            ['Nil']     = true,
            ['None']    = true
        }
    },

    -- boolean
    {   val = true,
        chk = {
            ['Boolean'] = true,
            ['True']    = true
        }
    },
    {   val = false,
        chk = {
            ['Boolean'] = true,
            ['None']    = true, 
            ['False']   = true
        }
    },

    -- string
    {   val = 'hello',
        chk = {
            ['String']  = true 
        }
    },
    {   val = 'world',
        chk = {
            ['String']  = true 
        }
    },
    {   val = '',
        chk = {
            ['String']  = true,
            ['None']     = true 
        }
    },

    -- number
    {   val = 0,
        chk = {
            ['Number']      = true,
            ['Finite']      = true,
            ['Unsigned']    = true,
            ['Int']         = true,
            ['Int8']        = true,
            ['Int16']       = true,
            ['Int32']       = true,
            ['UInt']        = true,
            ['UInt8']       = true,
            ['UInt16']      = true,
            ['UInt32']      = true,
            ['None']         = true 
        }
    },
    {   val = 1,
        chk = {
            ['Number']      = true,
            ['Finite']      = true,
            ['Unsigned']    = true,
            ['Int']         = true,
            ['Int8']        = true,
            ['Int16']       = true,
            ['Int32']       = true,
            ['UInt']        = true,
            ['UInt8']       = true,
            ['UInt16']      = true,
            ['UInt32']      = true,
        }
    },
    {   val = -1,
        chk = {
            ['Number']      = true,
            ['Finite']      = true,
            ['Int']         = true,
            ['Int8']        = true,
            ['Int16']       = true,
            ['Int32']       = true,
        }
    },
    {   val = 0.1,
        chk = {
            ['Number']  = true,
            ['Finite']  = true,
            ['Unsigned']= true 
        }
    },
    {   val = -0.1,
        chk = {
            ['Number']  = true,
            ['Finite']  = true 
        }
    },
    {   val = 1/0,
        chk = {
            ['Number']  = true 
        }
    },
    {   val = 0/0,
        chk = {
            ['Number']  = true,
            ['NaN']     = true,
            ['None']     = true 
        }
    },
    
    -- integer
    {   val = -128,
        chk = {
            ['Number']  = true,
            ['Finite']  = true,
            ['Int']     = true,
            ['Int8']    = true,
            ['Int16']   = true,
            ['Int32']   = true 
        }
    },
    {   val = 127,
        chk = {
            ['Number']  = true,
            ['Finite']  = true,
            ['Unsigned']= true,
            ['Int']     = true,
            ['Int8']    = true,
            ['Int16']   = true,
            ['Int32']   = true,
            ['UInt']    = true,
            ['UInt8']   = true,
            ['UInt16']  = true,
            ['UInt32']  = true,
        }
    },
    {   val = -32768,
        chk = {
            ['Number']  = true,
            ['Finite']  = true,
            ['Int']     = true,
            ['Int16']   = true,
            ['Int32']   = true
        }
    },
    {   val = 32767,
        chk = {
            ['Number']  = true,
            ['Finite']  = true,
            ['Unsigned']= true,
            ['Int']     = true,
            ['Int16']   = true,
            ['Int32']   = true,
            ['UInt']    = true,
            ['UInt16']  = true,
            ['UInt32']  = true,
        }
    },
    {   val = -2147483648,
        chk = {
            ['Number']  = true,
            ['Finite']  = true,
            ['Int']     = true,
            ['Int32']   = true 
        }
    },
    {   val = 2147483647,
        chk = {
            ['Number']  = true,
            ['Finite']  = true,
            ['Unsigned']= true,
            ['Int']     = true,
            ['Int32']   = true,
            ['UInt']    = true,
            ['UInt32']  = true,
        }
    },
    -- unsigned integer
    {   val = 255,
        chk = {
            ['Number']  = true,
            ['Finite']  = true,
            ['Unsigned']= true,
            ['Int']     = true,
            ['Int16']   = true,
            ['Int32']   = true,
            ['UInt']    = true,
            ['UInt8']   = true,
            ['UInt16']  = true,
            ['UInt32']  = true 
        }
    },
    {   val = 65535,
        chk = {
            ['Number']  = true,
            ['Finite']  = true,
            ['Unsigned']= true,
            ['Int']     = true,
            ['Int32']   = true,
            ['UInt']    = true,
            ['UInt16']  = true,
            ['UInt32']  = true
        }
    },
    {   val = 4294967295,
        chk = {
            ['Number']  = true,
            ['Finite']  = true,
            ['Unsigned']= true,
            ['Int']     = true,
            ['UInt']    = true,
            ['UInt32']  = true 
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
            ['Table']   = true 
        }
    },
    
    -- thread
    {   val = coroutine.create(function() end),
        chk = {
            ['Thread']  = true 
        }
    }
};
local nilVal;
local msg;

for _, field in ipairs( data ) do
    for method, res in pairs( field.chk ) do
        msg = ('is.%s( %s ) == %s'):format( 
            method, tostring( field.val ), tostring( res )
        );
        ifNotEqual( is[method]( field.val ), res, msg );
    end
end
