local M = {
    'monaqa/dial.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
}

-- took from LazyVim
-- https://github.com/LazyVim/LazyVim/blob/12818a6cb499456f4903c5d8e68af43753ebc869/lua/lazyvim/plugins/extras/editor/dial.lua
---@param increment boolean
---@param g? boolean
function M.dial(increment, g)
    local mode = vim.fn.mode(true)
    -- Use visual commands for VISUAL 'v', VISUAL LINE 'V' and VISUAL BLOCK '\22'
    local is_visual = mode == 'v' or mode == 'V' or mode == '\22'
    local func = (increment and 'inc' or 'dec') .. (g and '_g' or '_') .. (is_visual and 'visual' or 'normal')
    local group = vim.g.dials_by_ft[vim.bo.filetype] or 'default'
    return require('dial.map')[func](group)
end

M.keys = {
    { '<C-a>',  function() return M.dial(true) end,        expr = true, desc = 'Increment', mode = { 'n', 'v' } },
    { '<C-x>',  function() return M.dial(false) end,       expr = true, desc = 'Decrement', mode = { 'n', 'v' } },
    { 'g<C-a>', function() return M.dial(true, true) end,  expr = true, desc = 'Increment', mode = { 'n', 'v' } },
    { 'g<C-x>', function() return M.dial(false, true) end, expr = true, desc = 'Decrement', mode = { 'n', 'v' } },
}

M.opts = function()
    local augend = require('dial.augend')

    local logical_alias = augend.constant.new({
        elements = { '&&', '||' },
        word = false,
        cyclic = true,
    })

    local ordinal_numbers = augend.constant.new({
        -- elements through which we cycle. When we increment, we go down
        -- On decrement we go up
        elements = {
            'first',
            'second',
            'third',
            'fourth',
            'fifth',
            'sixth',
            'seventh',
            'eighth',
            'ninth',
            'tenth',
        },
        -- if true, it only matches strings with word boundary. firstDate wouldn't work for example
        word = false,
        -- do we cycle back and forth (tenth to first on increment, first to tenth on decrement).
        -- Otherwise nothing will happen when there are no further values
        cyclic = true,
    })

    local weekdays = augend.constant.new({
        elements = {
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday',
        },
        word = true,
        cyclic = true,
    })

    local months = augend.constant.new({
        elements = {
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
        },
        word = true,
        cyclic = true,
    })

    local short_us_date = augend.date.new({
        pattern = '%b %-d, %Y',
        default_kind = 'day',
        -- if true, it does not match dates which does not exist, such as 2022/05/32
        only_valid = true,
        -- if true, it only matches dates with word boundary
        word = false,
    })

    local capitalized_boolean = augend.constant.new({
        elements = {
            'True',
            'False',
        },
        word = true,
        cyclic = true,
    })

    return {
        dials_by_ft = {
            css = 'css',
            javascript = 'typescript',
            javascriptreact = 'typescript',
            json = 'json',
            lua = 'lua',
            markdown = 'markdown',
            python = 'python',
            sass = 'css',
            scss = 'css',
            typescript = 'typescript',
            typescriptreact = 'typescript',
            yaml = 'yaml',
        },
        groups = {
            default = {
                augend.constant.alias.bool,
                capitalized_boolean,
                augend.integer.alias.decimal_int,
                augend.integer.alias.hex,
                augend.semver.alias.semver,
                augend.date.alias['%Y/%m/%d'],
                augend.date.alias['%Y-%m-%d'],
                ordinal_numbers,
                weekdays,
                months,
            },
            typescript = {
                augend.integer.alias.decimal_int,
                augend.constant.alias.bool,
                logical_alias,
                augend.constant.new({ elements = { 'let', 'const' } }),
            },
            yaml = {
                augend.integer.alias.decimal_int,
                augend.constant.alias.bool,
            },
            css = {
                augend.integer.alias.decimal_int,
                augend.hexcolor.new({
                    case = 'lower',
                }),
                augend.hexcolor.new({
                    case = 'upper',
                }),
            },
            markdown = {
                augend.misc.alias.markdown_header,
                augend.semver.alias.semver,
                short_us_date,
            },
            json = {
                augend.integer.alias.decimal_int,
                augend.semver.alias.semver,
            },
            lua = {
                augend.integer.alias.decimal_int,
                augend.constant.alias.bool,
                augend.constant.new({
                    elements = { 'and', 'or' },
                    word = true,   -- if false, 'sand' is incremented into 'sor', 'doctor' into 'doctand', etc.
                    cyclic = true, -- 'or' is incremented into 'and'.
                }),
            },
            python = {
                augend.integer.alias.decimal_int,
                augend.semver.alias.semver,
                capitalized_boolean,
                logical_alias,
            },
        },
    }
end

M.config = function(_, opts)
    require('dial.config').augends:register_group(opts.groups)
    vim.g.dials_by_ft = opts.dials_by_ft
end

return M
