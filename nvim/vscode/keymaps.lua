local vscode = require('vscode')

vim.g.mapleader = ' '

vim.keymap.set('n', '<C-h>', function() vscode.action('workbench.action.navigateLeft') end)
vim.keymap.set('n', '<C-j>', function() vscode.action('workbench.action.navigateDown') end)
vim.keymap.set('n', '<C-k>', function() vscode.action('workbench.action.navigateUp') end)
vim.keymap.set('n', '<C-l>', function() vscode.action('workbench.action.navigateRight') end)

vim.keymap.set('n', 'za', function() vscode.action('editor.toggleFold') end)

vim.keymap.set({ 'n', 'x' }, '<leader>hs', function() vscode.action('git.stageSelectedRanges') end)
vim.keymap.set({ 'n', 'x' }, '<leader>hu', function() vscode.action('git.unstageSelectedRanges') end)
vim.keymap.set({ 'n', 'x' }, '<leader>hr', function() vscode.action('git.revertSelectedRanges') end)

vim.keymap.set({ 'n', 'x' }, ']h', function() vscode.action('workbench.action.editor.nextChange') end)
vim.keymap.set({ 'n', 'x' }, '[h', function() vscode.action('workbench.action.editor.previousChange') end)

vim.keymap.set({ 'n', 'x' }, '<leader>g', function() vscode.action('workbench.view.scm') end)
