local M = {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-colorscheme',
    },
    event = 'UIEnter',
    cond = not vim.g.vscode,
}

M.opts = function()
    local icons = require('config').defaults.icons
    local utils = require('config.fn-utils')

    local conditions = {
        buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
        end,
        hide_in_width = function()
            return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
            local filepath = vim.fn.expand('%:p:h')
            local gitdir = vim.fn.finddir('.git', filepath .. ';')
            return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
        is_python_file = function()
            return vim.bo.filetype == 'python'
        end,
        check_lsp_started = function()
            return next(vim.lsp.get_clients()) ~= nil
        end,
        check_session_exist = function()
            return utils.is_loaded('resession.nvim') and require('resession').get_current() ~= nil
        end,
        check_cmp_visible = function()
            return utils.is_loaded('blink.cmp') and require('blink.cmp').is_visible()
        end,
        check_hbac_loaded = function()
            return utils.is_loaded('hbac.nvim') ~= nil
        end,
    }

    local mode = {
        'mode',
        fmt = function(mode_string)
            return string.format('%-7s', mode_string)
        end,
        padding = { left = 1, right = 1 },
    }

    local session_status = {
        function()
            return vim.fn.fnamemodify(require('resession').get_current(), ':t')
        end,
        icon = icons.lualine.session,
        padding = { left = 1, right = 1 },
        cond = conditions.check_session_exist
    }

    local navic_location = {
        'navic',
        -- color_correction = 'dynamic',
        navic_opts = {
            separator = icons.lualine.navic_separator,
            highlight = true,
        },
        padding = { right = 0 },
    }

    -- local filename = {
    --     'filename',
    --     file_status = false, -- displays file status (readonly status, modified status)
    --     path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
    --     color = { gui = 'bold' },
    --     padding = { right = 0, left = 1 },
    --     cond = conditions.buffer_not_empty
    -- }

    local branch = {
        'branch',
        icons_enabled = true,
        icon = icons.lualine.git,
    }

    local spacing = {
        function()
            return '%='
        end,
    }

    local path = {
        function()
            if vim.bo.buftype ~= '' then
                return ''
            end
            local path = vim.fs.normalize(vim.fn.expand('%:.:h'))
            if #path == 0 then
                return ''
            end
            return path
        end,
        color = 'CmpGhostText',
    }

    local blink_info = { source_name = '', kind = 0 }
    local blink_kinds = {}
    local cmp_kind = {
        function()
            blink_kinds = require('blink.cmp.types').CompletionItemKind
            return '⌊' .. blink_info.source_name .. '⌉'
        end,
        color = function()
            return ('BlinkCmpKind' .. ((blink_kinds[blink_info.kind]) or ''))
        end,
        padding = { right = 8 },
        cond = conditions.check_cmp_visible
    }

    local cmp_label = {
        function()
            local info = require('blink.cmp').get_selected_item()
            blink_info.kind = info.kind
            blink_info.source_name = info.source_name

            return info.label
        end,
        padding = { right = 0 },
        cond = conditions.check_cmp_visible
    }

    local diagnostics = {
        'diagnostics',
        sections = { 'error', 'warn' },
        always_visible = true,
    }

    local lsp_status = {
        function()
            local attached_clients = vim.lsp.get_clients { bufnr = 0 }
            local it = vim.iter(attached_clients)
            it:map(function(client)
                local name = client.name:gsub('language.server', 'ls')
                return name
            end)
            local names = it:totable()
            return string.format('%s', table.concat(names, ' '))
        end,
        icon = icons.lualine.lsp,
        padding = { right = 2 },
        cond = conditions.check_lsp_started
    }

    local recording_mode = {
        require('noice').api.status.mode.get,
        cond = require('noice').api.status.mode.has,
        color = { fg = "#ff9e64" },
    }

    local location = {
        function()
            local cur = vim.fn.line('.')
            local total = vim.fn.line('$')
            local content = (cur == 1 and 'Top') or (cur == total and 'Bot') or
                string.format('%2d%%%%', math.floor(cur / total * 100))

            return string.format('[%s / %s]', content, total) .. ' :%2v'
        end,
        padding = { right = 1 },
        icon = icons.lualine.location
    }

    local swenv = {
        'swenv',
        icon = '󰌠',
        color = { fg = require('plugins.colorscheme.colorset').colors.cyan },
        cond = conditions.is_python_file,
    }

    local hbac = {
        function()
            local cur_buf = vim.api.nvim_get_current_buf()
            local _, pinned = pcall(require('hbac.state').is_pinned, cur_buf)
            return pinned and 'pinned' or ''
        end,
        color = 'WarningMsg',
        icon = icons.lualine.pinned,
        cond = conditions.check_hbac_loaded
    }

    return {
        options = {
            theme = require('plugins.colorscheme').lualine,
            icons_enabled = true,
            section_separators = ' ',
            component_separators = ' ',
            always_divide_middle = true,
        },
        sections = {
            lualine_a = { mode },
            lualine_b = { session_status, recording_mode },
            lualine_c = { branch, path, spacing, navic_location },
            lualine_x = { cmp_label, cmp_kind, hbac },
            lualine_y = { swenv, diagnostics, lsp_status },
            lualine_z = { location },
        },
        tabline = {},
        extensions = { 'lazy', 'mason', 'oil' }
    }
end

return M
