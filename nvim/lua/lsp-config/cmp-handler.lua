local cmp_loaded, cmp = pcall(require, 'cmp')
if not cmp_loaded then return end

local colors = require('colorscheme').colorset

-- ----------------------------------------------------------------------
--  luasnip configs
--
local luasnip_loaded, luasnip = pcall(require, 'luasnip')
if luasnip_loaded then
    luasnip.config.set_config({
        region_check_events = 'InsertEnter',
        delete_check_events = 'InsertLeave'
    })
    require('luasnip.loaders.from_vscode').lazy_load()
end

-- ----------------------------------------------------------------------
--  cmp configs
--
local function has_words_before()
    if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match('^%s*$') == nil
end

local cmp_icons = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = 'ﰠ',
    Variable = '',
    Class = 'ﴯ',
    Interface = '',
    Module = '',
    Property = 'ﰠ',
    Unit = '塞',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = 'פּ',
    Event = '',
    Operator = '',
    TypeParameter = '',
    Copilot = '',
}

local cmp_menu_icon = {
    nvim_lsp = 'LSP',
    luasnip = 'Snippet',
    buffer = 'Buffer',
    path = 'Path',
    nvim_lua = 'Lua',
    copilot = 'Copilot',
}

local cmp_formatting = {
    fields = { 'abbr', 'kind' },
    format = function(entry, vim_item)
        vim_item.menu = cmp_menu_icon[entry.source.name]
        vim_item.kind = string.format('%s %s', cmp_icons[vim_item.kind], vim_item.kind)
        return vim_item
    end,
}

local cmp_mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
    ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close()
    },
    ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true
    }),
    ['<Tab>'] = cmp.mapping(vim.schedule_wrap(function(fallback)
        if cmp.visible() and has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(vim.schedule_wrap(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end), { 'i', 's' })
}

local cmp_sources = cmp.config.sources({
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'luasnip', keyword_length = 2 },
})

local cmp_configs = {
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end, },
    mapping = cmp_mapping,
    sources = cmp_sources,
    formatting = cmp_formatting,
    window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered(),
    },
    experimental = {
        ghost_text = true
    },
    completion = {
        completeopt = 'menu,menuone,noselect',
        keyword_length = 3,
    }
}
cmp.setup(cmp_configs)

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- INFO: overrides Cmp highlight groups
vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = colors.green })
