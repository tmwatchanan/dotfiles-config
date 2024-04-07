local M =
{
    'JuliaEditorSupport/julia-vim',
    event = { 'BufReadPost', 'BufNewFile' },
}

local julia_program = 'julia'

local function run_julia_lsp(cmd, on_exit)
    local julia_lsp_cmd = table.concat({
        julia_program,
        '--project=~/.julia/environments/nvim-lspconfig',
        '-e',
        ("'import Pkg; %s'"):format(cmd),
    }, ' ')
    vim.fn.jobstart(julia_lsp_cmd, { on_exit = on_exit })
end

local function install_language_server()
    local function start_lsp()
        if vim.bo.filetype == 'julia' then
            vim.cmd('LspStart')
        end
    end

    local cmd = 'Pkg.add("LanguageServer"); Pkg.update("LanguageServer")'
    run_julia_lsp(cmd, start_lsp)
end

M.init = function()
    -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/julials.lua#L53-L73
    if vim.fn.executable(julia_program) == 1 then
        install_language_server()
    end
end

M.config = function()
    vim.g.latex_to_unicode_auto = 1
    vim.g.latex_to_unicode_tab = 'off'
end

return M
