local dap_module = {
    'mfussenegger/nvim-dap',
}

local dapui_module = {
    'rcarriga/nvim-dap-ui',
    dependencies = {
        'nvim-dap',
    },
    event = { 'VeryLazy' },
}

dap_module.config = function()
    local debuggers = require('plugins.lsp-settings.debuggers')
    require('mason-tool-installer').setup(debuggers)
    require('mason-tool-installer').check_install(false)
end

dap_module.keys = function()
    local keymap = require('config.keymaps').dap
    return {
        { keymap.ui,         function() require('dapui').toggle() end,          mode = 'n' },
        { keymap.breakpoint, function() require('dap').toggle_breakpoint() end, mode = 'n' },
        {
            keymap.breakpoint_condition,
            function()
                require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
            end,
            mode = 'n'
        },
        { keymap.continue,         function() require('dap').continue() end,               mode = 'n' },
        { keymap.terminate,        function() require('dap').terminate() end,              mode = 'n' },
        { keymap.step_over,        function() require('dap').step_over() end,              mode = 'n' },
        { keymap.step_into,        function() require('dap').step_into() end,              mode = 'n' },
        { keymap.step_out,         function() require('dap').step_out() end,               mode = 'n' },
        { keymap.python.method,    function() require('dap-python').test_method() end,     mode = 'n' },
        { keymap.python.class,     function() require('dap-python').test_class() end,      mode = 'n' },
        { keymap.python.selection, function() require('dap-python').debug_selection() end, mode = 'v' },
    }
end

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

local dap_virtual_text_module = {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = {
        'nvim-dap',
        'nvim-treesitter',
    },
    event = { 'VeryLazy' },
}

dap_virtual_text_module.config = function()
    require('nvim-dap-virtual-text').setup()
end

local dap_python_module = {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = {
        'nvim-dap-ui',
        'nvim-dap',
    },
    event = { 'VeryLazy' },
}

dap_python_module.config = function()
    local python_path = require('config.python').get_python_path()
    require('dap-python').test_runner = 'pytest'
    require('dap-python').setup(python_path)

    -- to launch debugger from the root of the project
    require('dap').configurations.python[1].cwd = '${workspaceFolder}'
    require('dap').configurations.python[2].cwd = '${workspaceFolder}'
end

return {
    dap_module,
    dapui_module,
    dap_virtual_text_module,
    dap_python_module,
}
