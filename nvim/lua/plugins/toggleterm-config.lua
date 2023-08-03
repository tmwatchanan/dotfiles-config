local toggleterm_keymap = require('config.keymaps').toggleterm

local M = {
	'akinsho/toggleterm.nvim',
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

M.keys = function()
	local Terminal = require('toggleterm.terminal').Terminal

	return {
		{
			toggleterm_keymap.toggle,
			desc = 'Toggle terminal'
		},
		{
			toggleterm_keymap.lazygit,
			function()
				Terminal:new({ cmd = 'lazygit', count = 20 }):toggle()
			end,
			desc = 'Toggle `lazygit` terminal',

		},
		{
			toggleterm_keymap.lazygit_file_history,
			function()
				Terminal:new({ cmd = 'lazygit -f ' .. vim.fn.expand('%'), count = 21 }):toggle()
			end,
			desc = 'Toggle file history in current buffer using `lazygit`',
		},
	}
end

return M
