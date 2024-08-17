local M = {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-treesitter',
        'nvim-neotest/neotest-python',
    }
}

M.config = function()
    require('neotest').setup({
        adapters = {
            require('neotest-python')({
                dap = { justMyCode = true },
                python = require('config.python').get_python_path(),
                args = {
                    '-s',
                    '-vv',
                    -- '--log-level', 'DEBUG',
                },
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
        { neotest_keymap.watch,            function() require('neotest').watch.toggle() end },
        { neotest_keymap.watch_file,       function() require('neotest').watch.toggle(vim.fn.expand('%')) end },
        { neotest_keymap.run_nearest,      function() require('neotest').run.run() end },
        { neotest_keymap.stop_nearest,     function() require('neotest').run.stop() end },
        { neotest_keymap.attach_nearest,   function() require('neotest').run.attach() end },
        { neotest_keymap.debug_nearest,    function() require('neotest').run.run({ strategy = 'dap' }) end },
        { neotest_keymap.run_current_file, function() require('neotest').run.run(vim.fn.expand('%')) end },
        { neotest_keymap.summary,          function() require('neotest').summary.toggle() end },
        { neotest_keymap.output_open,      function() require('neotest').output.open({ short = true }) end },
        { neotest_keymap.output_panel,     function() require('neotest').output_panel.toggle() end },
    }
end

return M
