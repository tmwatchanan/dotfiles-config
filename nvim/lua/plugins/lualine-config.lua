local M = {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-colorscheme' },
    event = 'VeryLazy',
}

M.init = function()
    -- set an empty statusline till lualine loads
    vim.o.statusline = ' '
end

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
    }

    local session_status = {
        function()
            return vim.fn.fnamemodify(require('resession').get_current(), ':t')
        end,
        icon = icons.lualine.session,
        cond = conditions.check_session_exist
    }

    local branch = {
        'branch',
        icons_enabled = true,
        icon = icons.lualine.git,
    }

    local path = {
    function()
        if vim.bo.buftype ~= '' then return '' end
        local path = vim.fs.normalize(vim.fn.expand('%:.:h'))
        return (#path > 0) and path or ''
    end,
        color = 'BlinkCmpGhostText',
    }

    -- local diff = {
    --     function()
    --         local gitsigns = vim.b.gitsigns_status_dict
    --         if not gitsigns then return '' end
    --
    --         local diff_icon = '▪'
    --         local parts = {}
    --
    --         if gitsigns.added and gitsigns.added > 0 then
    --             table.insert(parts, '%#GitSignsAdd#' .. diff_icon)
    --         end
    --         if gitsigns.changed and gitsigns.changed > 0 then
    --             table.insert(parts, '%#GitSignsChange#' .. diff_icon)
    --         end
    --         if gitsigns.removed and gitsigns.removed > 0 then
    --             table.insert(parts, '%#GitSignsDelete#' .. diff_icon)
    --         end
    --
    --         if #parts > 0 then
    --             return table.concat(parts) .. ' '
    --         end
    --         return ''
    --     end,
    -- }

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
        -- padding = { right = 8 },
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
        function()
            local severities = {
                { name = 'errors',   level = vim.diagnostic.severity.ERROR, hl = '%#DiagnosticError#' },
                { name = 'warnings', level = vim.diagnostic.severity.WARN,  hl = '%#DiagnosticWarn#' },
                { name = 'info',     level = vim.diagnostic.severity.INFO,  hl = '%#DiagnosticInfo#' },
                { name = 'hints',    level = vim.diagnostic.severity.HINT,  hl = '%#DiagnosticHint#' },
            }
            local icon = '▪'
            local total = 0
            local output = {}

            for _, sev in ipairs(severities) do
                local count = #vim.diagnostic.get(0, { severity = sev.level })
                total = total + count
                if count > 0 then
                    table.insert(output, sev.hl .. icon)
                end
            end

            if vim.bo.modifiable and total > 0 then
                return table.concat(output) .. ' '
            end

            return ''
        end,
    }

    local lsp_status = {
        function()
            local attached_clients = vim.lsp.get_clients { bufnr = 0 }
            local names = vim.iter(attached_clients)
                :map(function(client)
                    local name = client.name:gsub('language.server', 'ls')
                    return name
                end)
                :totable()
            return string.format('%s', table.concat(names, ' '))
        end,
        padding = { left = 1, right = 2 },
        icon = icons.lualine.lsp,
        cond = conditions.check_lsp_started
    }

    local location = {
        function()
            return '%3l:%-2c'
        end,
        icon = icons.lualine.location
    }

    local hbac = {
        function()
            local cur_buf = vim.api.nvim_get_current_buf()
            local _, pinned = pcall(require('hbac.state').is_pinned, cur_buf)
            return pinned and 'pinned buffer' or ''
        end,
        padding = { left = 1, right = 2 },
        color = 'WarningMsg',
        -- icon = icons.lualine.pinned,
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
            lualine_b = { session_status, branch },
            lualine_c = { path, '%=', cmp_label, cmp_kind },
            lualine_x = { diagnostics },
            lualine_y = { hbac, lsp_status },
            lualine_z = { location },
        },
        tabline = {},
        extensions = { 'lazy', 'mason', 'oil' }
    }
end

return M
