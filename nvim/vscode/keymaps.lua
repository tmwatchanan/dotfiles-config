local vscode = require('vscode')

vim.keymap.set('n', '<C-h>', function() vscode.action('workbench.action.navigateLeft') end)
vim.keymap.set('n', '<C-j>', function() vscode.action('workbench.action.navigateDown') end)
vim.keymap.set('n', '<C-k>', function() vscode.action('workbench.action.navigateUp') end)
vim.keymap.set('n', '<C-l>', function() vscode.action('workbench.action.navigateRight') end)

vim.keymap.set('n', 'za', function() vscode.action('editor.toggleFold') end)
