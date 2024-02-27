local M = {}

local is_windows = function()
    return vim.uv.os_uname().sysname:find("Windows", 1, true) and true
end

M.get_python_path = function()
    local venv_path = os.getenv('VIRTUAL_ENV')
    if venv_path then
        if is_windows() then
            return venv_path .. '\\Scripts\\python.exe'
        end
        return venv_path .. '/bin/python'
    end

    venv_path = os.getenv("CONDA_PREFIX")
    if venv_path then
        if is_windows() then
            return venv_path .. '\\python.exe'
        end
        return venv_path .. '/bin/python'
    end

    return '/opt/homebrew/Caskroom/miniforge/base/bin/python'
end

M.get_environment_path = function()
    local python_path = M.get_python_path()
    return python_path .. '/../..'
end

return M
