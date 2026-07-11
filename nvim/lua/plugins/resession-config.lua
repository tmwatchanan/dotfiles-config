local M = {
    'stevearc/resession.nvim',
    lazy = false,
    cond = not vim.g.vscode,
}

-- NOTE: MRU list of project dirs jumped away from in this instance (most recent first)
local recent = {}

local function remove_recent(dir)
    for i, d in ipairs(recent) do
        if d == dir then
            table.remove(recent, i)
            return
        end
    end
end

function M.switch_project(dir)
    dir = vim.fs.normalize(dir)
    local cwd = vim.fn.getcwd()
    if dir == cwd then
        return
    end

    local resession = require('resession')
    resession.save(cwd, { notify = false })
    remove_recent(cwd)
    table.insert(recent, 1, cwd)
    remove_recent(dir)

    vim.fn.chdir(dir)
    if not pcall(resession.load, dir) then
        -- NOTE: no session for this project yet: start clean, then save so
        -- the project is tracked and the exit autosave keeps it fresh
        vim.cmd('silent! %bwipeout')
        resession.save(dir, { notify = false })
    end
end

function M.swap_project()
    if recent[1] then
        M.switch_project(recent[1])
    else
        vim.notify('No previous project to swap to', vim.log.levels.INFO)
    end
end

function M.pick_project()
    require('snacks').picker.projects {
        confirm = function(picker, item)
            picker:close()
            if item and item.file then
                M.switch_project(item.file)
            end
        end,
    }
end

function M.pick_recent()
    local items = {}
    for i, dir in ipairs(recent) do
        items[#items + 1] = { idx = i, score = 0, text = dir, file = dir, dir = true }
    end
    require('snacks').picker {
        title = 'Jumped Projects',
        items = items,
        format = 'file',
        sort = { fields = { 'idx' } },
        confirm = function(picker, item)
            picker:close()
            if item and item.file then
                M.switch_project(item.file)
            end
        end,
    }
end

M.config = function()
    local resession = require('resession')
    resession.setup {}

    -- NOTE: load a dir-specific session when open nvim, save when exit.
    vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
            if vim.fn.argc(-1) == 0 then
                resession.load(vim.fn.getcwd(), { silence_errors = true })
            end
        end,
        nested = true,
    })
    vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
            -- NOTE: save only exist session
            local files = require('resession.files')
            local current_session = string.format('%s', vim.fn.getcwd():gsub(files.sep, '_'):gsub(':', '_'))

            for _, session_name in ipairs(resession.list()) do
                if session_name == current_session then
                    resession.save(vim.fn.getcwd(), { notify = true })
                    return
                end
            end
        end,
    })
end

M.keys = function()
    local resession_keymap = require('config.keymaps').resession

    return {
        { resession_keymap.save,         function() require('resession').save(vim.fn.getcwd()) end },
        { resession_keymap.delete,       function() require('resession').delete() end },
        { resession_keymap.pick_project, M.pick_project },
        { resession_keymap.pick_recent,  M.pick_recent },
        { resession_keymap.swap,         M.swap_project },
    }
end

return M
