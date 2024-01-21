-- THEME
vim.opt.termguicolors = true
vim.opt.background='dark'

-- QOL settings
HOME = os.getenv("HOME")
vim.opt.backupdir = HOME .. '/.config/nvim/tmp/backup_files/'
vim.opt.directory = HOME .. '/.config/nvim/tmp/swap_files/'
vim.opt.undodir = HOME .. '/.config/nvim/tmp/undo_files/'
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.scrolloff=10
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.relativenumber = true
vim.opt.clipboard = 'unnamedplus'

vim.cmd([[
set completeopt=menu,menuone,noselect
]])

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ LSP Diagnostics ]]
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = false,
})
-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 500
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
