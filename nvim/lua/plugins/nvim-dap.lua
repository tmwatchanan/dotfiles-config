local dap_python_module = {
    'mfussenegger/nvim-dap-python',
    cond = not vim.g.vscode,
}

dap_python_module.config = function()
    local python_path = require('config.python').get_python_path()
    require('dap-python').setup(python_path)

    -- NOTE: below might resolve the issue with frozen modules since Python 3.11
    -- require('dap-python').resolve_python = function()
    --     local module_flag = '-Xfrozen_modules=off'
    --     return ('%s %s'):format(python_path, module_flag)
    -- end

    require('dap-python').test_runner = 'pytest'

    local dap = require('dap')
    local utils = require('config.fn-utils')
    for i = 1, 2 do
        dap.configurations.python[i] = utils.merge(
            dap.configurations.python[i],
            {
                cwd = '${workspaceFolder}', -- to launch debugger from the root of the project
                env = {
                    -- NOTE: `pytest-cov` issue according to VS Code
                    -- https://code.visualstudio.com/docs/python/testing#_pytest-configuration-settings
                    ["PYTEST_ADDOPTS"] = '--no-cov',
                },
                justMyCode = false,
            }
        )
    end
end
local function setup_dap_signs()
    local colors = require('plugins.colorscheme.colorset').colors
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = colors.red })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = colors.info })
    vim.api.nvim_set_hl(0, 'DapStopped', { fg = colors.red })
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = colors.bg2 })
    vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { bg = colors.bg2 })

    local dap_icons = require('config').defaults.icons.dap
    local dap_signs = {
        { name = 'DapBreakpoint',          text = dap_icons.breakpoint,           texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' },
        { name = 'DapBreakpointCondition', text = dap_icons.breakpoint_condition, texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' },
        { name = 'DapBreakpointRejected',  text = dap_icons.breakpoint_rejected,  texthl = 'DapBreakpoint', linehl = 'DapBreakpointRejected', numhl = 'DapBreakpoint' },
        { name = 'DapLogPoint',            text = dap_icons.log_point,            texthl = 'DapLogPoint',   numhl = 'DapLogPoint' },
        { name = 'DapStopped',             text = dap_icons.stopped,              texthl = 'DapStopped',    linehl = 'DapStoppedLine',        numhl = 'DapStopped' },
    }
    for _, sign in ipairs(dap_signs) do
        vim.fn.sign_define(sign.name,
            { text = sign.text, texthl = sign.texthl, linehl = sign.linehl, numhl = sign.numhl })
    end
end


local persistent_breakpoints_module = {
    'Weissle/persistent-breakpoints.nvim',
    opts = {
        load_breakpoints_event = 'BufReadPost'
    },
    event = 'BufReadPost',
    config = function(_, opts)
        require('persistent-breakpoints').setup(opts)
        setup_dap_signs()
    end,
    cond = not vim.g.vscode,
}

local dap_module = {
    'mfussenegger/nvim-dap',
    dependencies = {
        dap_python_module,
        'jay-babu/mason-nvim-dap.nvim',
    },
    cond = not vim.g.vscode,
    config = function()
        require('mason-nvim-dap').setup({
            ensure_installed = {
                'python', -- debugpy
            },
        })

        require('dap').defaults.python.exception_breakpoints = { 'raised', 'uncaught' } -- debugpy
    end,
}


local dapui_module = {
    'rcarriga/nvim-dap-ui',
    dependencies = {
        'nvim-dap',
        'nvim-neotest/nvim-nio',
        {
            'theHamsta/nvim-dap-virtual-text',
            dependencies = {
                'nvim-treesitter',
            },
        },
        'LiadOz/nvim-dap-repl-highlights',
        {
            'rcarriga/cmp-dap',
            config = function()
                require('cmp').setup({
                    enabled = function()
                        return vim.api.nvim_get_option_value('buftype', { buf = 0 }) ~= 'prompt'
                            or require('cmp_dap').is_dap_buffer()
                    end
                })

                require('cmp').setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
                    sources = {
                        { name = 'dap' },
                    },
                })
            end
        },
    },
    cond = not vim.g.vscode,
}

dapui_module.config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    dapui.setup()
    dap.listeners.after.event_initialized['dapui_config'] = function()
        require('focus').setup({ autoresize = { enable = false } })
        dapui.open()
    end
    dap.listeners.before.event_initialized['dapui_config'] = function()
        require('focus').setup({ autoresize = { enable = true } })
        dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
        require('focus').setup({ autoresize = { enable = true } })
        dapui.close()
    end
end

dapui_module.keys = function()
    local keymap = require('config.keymaps').dap
    return {
        { keymap.ui,                    function() require('dapui').toggle() end,                                          mode = 'n' },
        { keymap.breakpoint,            function() require('persistent-breakpoints.api').toggle_breakpoint() end,          mode = 'n' },
        { keymap.breakpoint_condition,  function() require('persistent-breakpoints.api').set_conditional_breakpoint() end, mode = 'n' },
        { keymap.clear_all_breakpoints, function() require('persistent-breakpoints.api').clear_all_breakpoints() end,      mode = 'n' },
        { keymap.log_point,             function() require('persistent-breakpoints.api').set_log_point() end,              mode = 'n' },
        { keymap.continue,              function() require('dap').continue() end,                                          mode = 'n' },
        {
            keymap.terminate,
            function()
                require('dap').terminate()
                require('dapui').close()
            end,
            mode = 'n'
        },
        { keymap.step_over,        function() require('dap').step_over() end,              mode = 'n' },
        { keymap.step_into,        function() require('dap').step_into() end,              mode = 'n' },
        { keymap.step_out,         function() require('dap').step_out() end,               mode = 'n' },
        { keymap.run_to_cursor,    function() require('dap').run_to_cursor() end,          mode = 'n' },
        { keymap.eval,             function() require('dapui').eval() end,                 mode = { 'n', 'x' } },
        { keymap.python.method,    function() require('dap-python').test_method() end,     mode = 'n' },
        { keymap.python.class,     function() require('dap-python').test_class() end,      mode = 'n' },
        { keymap.python.selection, function() require('dap-python').debug_selection() end, mode = 'x' },
    }
end

return {
    dap_module,
    dapui_module,
    persistent_breakpoints_module,
}
