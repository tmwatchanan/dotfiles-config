local M = {
    'chrisgrieser/nvim-spider',
}

M.keys = {
    { ',w', 'w',                                          mode = { 'n', 'o', 'x' } },
    { ',e', 'e',                                          mode = { 'n', 'o', 'x' } },
    { ',b', 'b',                                          mode = { 'n', 'o', 'x' } },
    { 'w',  function() require('spider').motion('w') end, mode = { 'n', 'o', 'x' } },
    { 'e',  function() require('spider').motion('e') end, mode = { 'n', 'o', 'x' } },
    { 'b',  function() require('spider').motion('b') end, mode = { 'n', 'o', 'x' } },
}

return M
