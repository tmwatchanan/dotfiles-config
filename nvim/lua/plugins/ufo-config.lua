local M = {
    'kevinhwang91/nvim-ufo',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'kevinhwang91/promise-async' },
    cond = not vim.g.vscode,
}

M.opts = {
    preview = {
        win_config = {
            border = require('config').defaults.float_border,
            winhighlight = 'Normal:FloatBorder',
            winblend = 0,
        },
    },
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('  %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
                table.insert(newVirtText, chunk)
            else
                chunkText = truncate(chunkText, targetWidth - curWidth)
                local hlGroup = chunk[2]
                table.insert(newVirtText, { chunkText, hlGroup })
                chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if curWidth + chunkWidth < targetWidth then
                    suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                end
                break
            end
            curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
    end,
}

M.keys = function()
    local ufo_keymap = require('config.keymaps').ufo
    return {
        { ufo_keymap.open_all,    function() require('ufo').openAllFolds() end },
        { ufo_keymap.open_except, function() require('ufo').openFoldsExceptKinds() end },
        { ufo_keymap.close_all,   function() require('ufo').closeAllFolds() end },
        { ufo_keymap.close_with,  function() require('ufo').closeFoldsWith() end },
    }
end

return M
