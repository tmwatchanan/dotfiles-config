local M = {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    -- ft = 'markdown',
    event = {
        -- only load obsidian.nvim for markdown files in vault:
        "BufReadPre " .. vim.fn.expand "~" .. "/tm/obsidian/**.md",
        "BufNewFile " .. vim.fn.expand "~" .. "/tm/obsidian/**.md",
    },
    dependencies = {
        'plenary.nvim',
        'nvim-cmp',
        'telescope.nvim',
        'nvim-treesitter',
    },
}

M.opts = {
    workspaces = {
        {
            name = 'know-how',
            path = '~/tm/obsidian/know-how',
        },
        {
            name = 'personal',
            path = '~/tm/obsidian/personal',
        },
    },
}

M.config = function(_, opts)
    vim.opt_local.conceallevel = 2
    require('obsidian').setup(opts)
end

M.keys = function()
    local keymap = require('config.keymaps').obsidian
    return {
        { keymap.search,          '<Cmd>ObsidianSearch<CR>',         desc = '[Obsidian] Search' },
        { keymap.workspace,       '<Cmd>ObsidianWorkspace<CR>',      desc = '[Obsidian] Workspace' },
        { keymap.quick_switch,    '<Cmd>ObsidianQuickSwitch<CR>',    desc = '[Obsidian] Quick switch' },
        { keymap.paste_image,     ':ObsidianPasteImg ',              desc = '[Obsidian] Paste image from clipboard' },
        { keymap.rename,          ':ObsidianRename ',                desc = '[Obsidian] Paste image from clipboard' },
        { keymap.toggle_checkbox, '<Cmd>ObsidianToggleCheckbox<CR>', desc = '[Obsidian] Paste image from clipboard' },
    }
end

return M
