vim.filetype.add({
    pattern = {
        ['%.env%.[%w_.-]+'] = 'sh',
        ['%.gitconfig%.[%w_.-]+'] = 'gitconfig',
    },
})
