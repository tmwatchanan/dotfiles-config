local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd "packadd packer.nvim"
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    desc = "Sync packer after modifying plugins.lua",
    group = "packer_user_config",
    pattern = "plugins.lua",
    command = "source <afile> | PackerSync"
})

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

return packer.startup({
    function(use)
        use 'wbthomason/packer.nvim'
        use 'nvim-lua/plenary.nvim'
        use 'nvim-lua/popup.nvim'
        use 'lewis6991/impatient.nvim'

        -- LSP
        use {
            'VonHeikemen/lsp-zero.nvim',
            requires = {
                -- LSP Support
                { 'neovim/nvim-lspconfig' },
                { 'williamboman/nvim-lsp-installer' },

                -- Autocompletion
                { 'hrsh7th/nvim-cmp' },
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'hrsh7th/cmp-nvim-lua' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-path' },
                { 'hrsh7th/cmp-cmdline' },
                { 'saadparwaiz1/cmp_luasnip' },

                -- Snippets
                { 'L3MON4D3/LuaSnip' },
                { 'rafamadriz/friendly-snippets' },
            }
        }
        use 'RRethy/vim-illuminate'
        use 'antoinemadec/FixCursorHold.nvim'

        -- git plugins
        use 'lewis6991/gitsigns.nvim'

        -- telescope
        use 'nvim-telescope/telescope.nvim'
        use 'nvim-telescope/telescope-file-browser.nvim'
        use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        use 'nvim-telescope/telescope-ui-select.nvim'

        -- utilities
        use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' }
        use 'numToStr/Comment.nvim'
        use 'lukas-reineke/indent-blankline.nvim'
        use 'moll/vim-bbye'
        use 'norcalli/nvim-colorizer.lua'
        use 'windwp/nvim-autopairs'
        use 'akinsho/toggleterm.nvim'
        use 'beauwilliams/focus.nvim'
        use 'chentoast/marks.nvim'
        use { 'ggandor/leap.nvim', config = function() require('leap').set_default_keymaps() end }
        use 'Shatur/neovim-session-manager'

        -- UI decoration
        use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
        use 'nvim-treesitter/nvim-treesitter-textobjects'
        use 'p00f/nvim-ts-rainbow'
        use 'windwp/nvim-ts-autotag'
        use 'JoosepAlviste/nvim-ts-context-commentstring'
        use 'nvim-lualine/lualine.nvim'
        use 'kyazdani42/nvim-web-devicons'
        use 'folke/todo-comments.nvim'
        use 'kevinhwang91/nvim-hlslens'
        -- use 'MomePP/plastic-nvim'
        use 'rebelot/kanagawa.nvim'
        use { 'SmiteshP/nvim-gps', config = function() require('nvim-gps').setup() end }
        use 'b0o/incline.nvim'
        use 'folke/lsp-colors.nvim'

        -- misc. cool stuff
        -- use 'andweeb/presence.nvim' -- discord activity status

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if PACKER_BOOTSTRAP then
            require("packer").sync()
        end
    end
})
