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

vim.keymap.set({ 'n', 'x' }, '<leader>dbc', function() vscode.action('workbench.debug.action.toggleRepl') end)
vim.keymap.set({ 'n', 'x' }, '<leader>dbe', function()
    vscode.action('editor.debug.action.selectionToRepl')
    vscode.action('vscode-neovim.escape')
end)

vim.keymap.set({ 'n', 'x' }, '<leader>sf', function() vscode.action('workbench.action.quickOpen') end)
vim.keymap.set({ 'n', 'x' }, '<leader>ss', function() vscode.action('workbench.action.gotoSymbol') end)
vim.keymap.set({ 'n', 'x' }, '<leader>sa', function() vscode.action('workbench.action.showAllSymbols') end)
