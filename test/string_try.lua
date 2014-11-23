local util = require('util');
local str = ' a.b.c..d ';

ifNotEqual( util.string.charAt( str, 3 ), '.' );
ifNotEqual( 
    inspect( { util.string.charCodeAt( str, 1, 5 ) } ), 
    inspect( { 32, 97, 46, 98, 46 } )
);
ifNotEqual( 
    inspect( util.string.split( str, '%.' ) ), 
    inspect( { ' a', 'b', 'c', 'd ' } )
);
ifNotEqual( util.string.trim( str ), 'a.b.c..d' );

