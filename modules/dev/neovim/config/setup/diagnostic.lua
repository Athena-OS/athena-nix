vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    float = { border = "single" },
})
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]


