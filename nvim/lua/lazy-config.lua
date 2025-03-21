-- INFO: lazy.nvim bootstrap checking
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup {
    spec = {
        { import = 'plugins' },
    },
    defaults = {
        lazy = true
    },
    install = {
        colorscheme = { 'nvim-colorscheme' }
    },
    ui = {
        border = 'solid',
        backdrop = 100,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                '2html_plugin',
                'getscript',
                'getscriptPlugin',
                'gzip',
                'logipat',
                -- 'netrw',
                -- 'netrwPlugin',
                -- 'netrwSettings',
                -- 'netrwFileHandlers',
                'matchit',
                'matchparen',
                'tar',
                'tarPlugin',
                'tohtml',
                'tutor',
                'rrhelper',
                'vimball',
                'vimballPlugin',
                'zip',
                'zipPlugin',
            },
        },
    },
    dev = {
        path = '~/tm/nvim-plugins',
    }
}

-- INFO: lazy.nvim keybinding
local lazy_keymap = require('config.keymaps').lazy
vim.keymap.set('n', lazy_keymap.open, '<Cmd>Lazy<CR>')
