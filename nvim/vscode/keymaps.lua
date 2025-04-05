local vscode = require('vscode')

vim.g.mapleader = ' '

-- INFO: navigation
vim.keymap.set('n', '<C-h>', function() vscode.action('workbench.action.navigateLeft') end)
vim.keymap.set('n', '<C-j>', function() vscode.action('workbench.action.navigateDown') end)
vim.keymap.set('n', '<C-k>', function() vscode.action('workbench.action.navigateUp') end)
vim.keymap.set('n', '<C-l>', function() vscode.action('workbench.action.navigateRight') end)

vim.keymap.set('n', 'za', function() vscode.action('editor.toggleFold') end)

-- INFO: git scm
vim.keymap.set({ 'n', 'x' }, '<leader>g', function() vscode.action('workbench.view.scm') end)
vim.keymap.set({ 'n', 'x' }, '<leader>hs', function() vscode.action('git.stageSelectedRanges') end)
vim.keymap.set({ 'n', 'x' }, '<leader>hu', function() vscode.action('git.unstageSelectedRanges') end)
vim.keymap.set({ 'n', 'x' }, '<leader>hr', function() vscode.action('git.revertSelectedRanges') end)
vim.keymap.set({ 'n', 'x' }, ']h', function() vscode.action('workbench.action.editor.nextChange') end)
vim.keymap.set({ 'n', 'x' }, '[h', function() vscode.action('workbench.action.editor.previousChange') end)

-- INFO: go to
vim.keymap.set({ 'n', 'x' }, '<leader>fs', function() vscode.action('workbench.action.quickOpen') end)
vim.keymap.set({ 'n', 'x' }, '<leader>ss', function() vscode.action('workbench.action.gotoSymbol') end)
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function() vscode.action('workbench.action.showAllSymbols') end)

-- INFO: testing
vim.keymap.set({ 'n', 'x' }, '<leader>tt', function() vscode.action('workbench.view.testing.focus') end)
vim.keymap.set({ 'n', 'x' }, '<leader>tr', function() vscode.action('testing.refreshTests') end)
vim.keymap.set({ 'n', 'x' }, '<leader>to', function() vscode.action('testing.showMostRecentOutput') end)
vim.keymap.set({ 'n', 'x' }, '<leader>tp', function() vscode.action('testing.openOutputPeek') end)
vim.keymap.set({ 'n', 'x' }, '<leader>tn', function() vscode.action('testing.runAtCursor') end)
vim.keymap.set({ 'n', 'x' }, '<leader>tl', function() vscode.action('testing.reRunLastRun') end)
vim.keymap.set({ 'n', 'x' }, '<leader>tf', function() vscode.action('testing.reRunFailTests') end)
vim.keymap.set({ 'n', 'x' }, '<leader>tF', function() vscode.action('testing.runCurrentFile') end)
vim.keymap.set({ 'n', 'x' }, '<leader>ta', function() vscode.action('testing.runAll') end)
vim.keymap.set({ 'n', 'x' }, '<leader>td', function() vscode.action('testing.debugAtCursor') end)

-- INFO: debugging
vim.keymap.set({ 'n', 'x' }, '<leader>dbc', function() vscode.action('workbench.debug.action.toggleRepl') end)
vim.keymap.set({ 'n', 'x' }, '<leader>dbe', function()
    vscode.action('editor.debug.action.selectionToRepl')
    vscode.action('vscode-neovim.escape')
end)

