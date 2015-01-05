local lastIndex = require('util').table.lastIndex;

ifTrue(isolate(function()
    lastIndex();
end));
ifNotNil( lastIndex({ a = 1 }) );
ifNotEqual( lastIndex({ a = 1, 2, 3 }), 2 );
ifNotEqual( lastIndex({ a = 1, 2, 3, 'b' }), 3 );
ifNotEqual( lastIndex({ a = 1, 2, 3, 'b', c = 4 }), 3 );
ifNotEqual( lastIndex({ a = 1, 2, 3, 'b', c = 4, 'd' }), 4 );
ifNotEqual( lastIndex({ a = 1, 2, 3, 'b', c = 4, 'd', 5 }), 5 );
ifNotEqual( lastIndex({ a = 1, 2, 3, 'b', c = 4, 'd', 5, [-10] = 'e', [123] = 'e' }), 123 );
