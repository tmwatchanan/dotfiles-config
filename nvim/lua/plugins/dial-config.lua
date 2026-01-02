local M = {
    'monaqa/dial.nvim',
}

M.keys = {
    { '<C-a>',  function() require("dial.map").manipulate("increment", "normal") end,  noremap = true, mode = 'n' },
    { '<C-x>',  function() require('dial.map').manipulate("decrement", "normal") end,  noremap = true, mode = 'n' },
    { 'g<C-a>', function() require('dial.map').manipulate("increment", "gnormal") end, noremap = true, mode = 'n' },
    { 'g<C-x>', function() require('dial.map').manipulate("decrement", "gnormal") end, noremap = true, mode = 'n' },
    { '<C-a>',  function() require('dial.map').manipulate("increment", "visual") end,  noremap = true, mode = 'v' },
    { '<C-x>',  function() require('dial.map').manipulate("decrement", "visual") end,  noremap = true, mode = 'v' },
    { 'g<C-a>', function() require('dial.map').manipulate("increment", "gvisual") end, noremap = true, mode = 'v' },
    { 'g<C-x>', function() require('dial.map').manipulate("decrement", "gvisual") end, noremap = true, mode = 'v' },
}

M.config = function()
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
        elements = { 'True', 'False' },
        word = true,
        cyclic = true,
    })

    local theme = augend.constant.new({
        elements = { 'light', 'dark' },
        word = true,
        cyclic = true,
    })

    require("dial.config").augends:register_group {
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
            theme,
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
            augend.constant.alias.bool,
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
    }
end

return M
