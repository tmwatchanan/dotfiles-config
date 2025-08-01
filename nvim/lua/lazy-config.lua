-- INFO: lazy.nvim bootstrap checking
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out,                            'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
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
        colorscheme = { require('plugins.colorscheme').colorscheme or 'default' }
    },
    ui = {
        border = 'solid',
        backdrop = 100,
    },
    rocks = {
        enabled = false
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
