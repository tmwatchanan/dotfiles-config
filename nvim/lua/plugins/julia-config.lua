local M = {
    enabled = false,
    'JuliaEditorSupport/julia-vim',
    lazy = false,
    ft = 'julia',
    cond = not vim.g.vscode,
}

local julia_program = 'julia'

local function julia_run(cmd, on_exit)
    local julia_lsp_cmd = table.concat({
        julia_program,
        '--project=~/.julia/environments/nvim-lspconfig',
        '-e',
        ("'import Pkg; %s'"):format(cmd)
    }, ' ')
    -- vim.fn.jobstart(julia_lsp_cmd, { on_exit = vim.schedule_wrap(on_exit) })
    vim.fn.jobstart(julia_lsp_cmd)
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/julials.lua#L53-L73
M.install_language_server = function()
    local function start_lsp()
        if vim.bo.filetype == 'julia' then
            vim.cmd('LspStart')
        end
    end

    if vim.fn.executable(julia_program) == 1 then
        local cmd = 'Pkg.add("LanguageServer");'
        julia_run(cmd, start_lsp)
    end
end

M.init = function()
    vim.g.latex_to_unicode_auto = 1
    vim.g.latex_to_unicode_tab = 'off'
end

return M
