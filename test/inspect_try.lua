local inspect = require('util').inspect;

local fn = function() end;
local co = coroutine.create(function() end);
local tbl = {
    -- boolean
    true, false,
    -- string
    'hello', 'world', '',
    -- number
    0, 1, -1,
    -- function
    fn,
    -- table
    {},
    -- finite
    1/0, 
    -- NaN
    0/0, 
    -- thread
    co,
    [co] = {
        'test'
    },
    ['test'] = 'sample',
    [true] = true,
    [false] = false,
    [100.1] = 100.1
};
local cmp = [[
{
    [1] = true,
    [2] = false,
    [3] = "hello",
    [4] = "world",
    [5] = "",
    [6] = 0,
    [7] = 1,
    [8] = -1,
    [9] = "]] .. tostring(fn) .. [[",
    [10] = {},
    [11] = inf,
    [12] = nan,
    [13] = "]] .. tostring(co) .. [[",
    [100.1] = 100.1,
    [false] = false,
    test = "sample",
    [true] = true,
    ["]] .. tostring(co) .. [["] = {
        [1] = "test"
    }
}]];
ifNotEqual( inspect( tbl ), cmp );
