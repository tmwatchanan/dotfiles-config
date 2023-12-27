local M = {
    "nat-418/boole.nvim",
    event = { 'BufReadPost', 'BufNewFile' },
}

M.opts = {
    mappings = {
        increment = '<C-c>',
        decrement = '<C-x>'
    },
    -- User defined loops
    additions = {
        { 'Foo', 'Bar' },
        { 'tic', 'tac', 'toe' }
    },
    allow_caps_additions = {
        { 'enable', 'disable' }
        -- enable → disable
        -- Enable → Disable
        -- ENABLE → DISABLE
    }
}

return M
