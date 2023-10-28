local M = {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-neotest/neotest-python',
        'nvim-neotest/neotest-plenary',
        'nvim-neotest/neotest-vim-test',
    }
}

M.config = function()
    require('neotest').setup({
        adapters = {
            require('neotest-python')({
                dap = { justMyCode = false },
                python = require('config.python').get_python_path(),
            }),
            require('neotest-plenary'),
            require('neotest-vim-test')({
                ignore_file_types = { 'python', 'vim', 'lua' },
            }),
        },
    })
end

M.keys = function()
    local neotest_keymap = require('config.keymaps').neotest

    return {
        { neotest_keymap.run_nearest,      function() require('neotest').run.run() end },
        { neotest_keymap.stop_nearest,     function() require('neotest').run.stop() end },
        { neotest_keymap.attach_nearest,   function() require('neotest').run.attach() end },
        { neotest_keymap.debug_nearest,    function() require('neotest').run.run({ strategy = 'dap' }) end },
        { neotest_keymap.run_current_file, function() require('neotest').run.run(vim.fn.expand('%')) end },
        { neotest_keymap.summary,          function() require('neotest').summary.toggle() end },
        { neotest_keymap.output_panel,     function() require('neotest').output_panel.toggle() end },
    }
end

return M
