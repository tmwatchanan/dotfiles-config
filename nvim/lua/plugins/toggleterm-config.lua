local toggleterm_keymap = require('config.keymaps').toggleterm

local M = {
	'akinsho/toggleterm.nvim',
    cond = not vim.g.vscode,
}

-- M.init = function ()
-- 	-- local gotop = Terminal:new({ cmd = 'gotop', count = 21, hidden = true })
-- 	-- local node = Terminal:new({ cmd = 'node', hidden = true })
-- 	-- local ncdu = Terminal:new({ cmd = 'ncdu', hidden = true })
-- 	-- local python = Terminal:new({ cmd = 'python', hidden = true })
-- 	-- local spotify = Terminal:new({ cmd = 'spt', hidden = true })

-- 	-- 	function _G.setup_terminal_config()
-- 	-- 		-- set terminal keymap
-- 	-- 		local key_opts = { buffer = 0 }
-- 	-- 		vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], key_opts)
-- 	-- 	end
-- 	--
-- 	-- 	vim.cmd('autocmd! TermOpen term://* lua setup_terminal_config()')
-- end

M.opts = {
	size = 20,
	open_mapping = toggleterm_keymap.toggle,
	shade_terminals = false,
	direction = 'tab',
}

M.keys = {
	{
		toggleterm_keymap.toggle,
		desc = 'Toggle terminal'
	},
	{
		toggleterm_keymap.lazygit,
		function()
			local environment_path = require('config.python').get_environment_path()
			require('toggleterm.terminal').Terminal
				:new({
					cmd = ('mamba activate %s ; cd $(readlink -f .) & lg'):format(environment_path),
					count = M.opts.size + 1,
					hidden = false,
					on_open = function()
						vim.opt_local.signcolumn = 'no'
					end,
				})
				:toggle()
		end,
		desc = 'Toggle `lazygit` terminal',

	},
	{
		toggleterm_keymap.lazygit_file_history,
		function()
			local resolved_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':p')
			require('toggleterm.terminal').Terminal
				:new({
					cmd = ('cd $(readlink -f .) & lg -f %s'):format(resolved_path),
					count = M.opts.size + 2,
					hidden = false,
					on_open = function()
						vim.opt_local.signcolumn = 'no'
					end,
				})
				:toggle()
		end,
		desc = 'Toggle file history in current buffer using `lazygit`',
	},
}

return M
