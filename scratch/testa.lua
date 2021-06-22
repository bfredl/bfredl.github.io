buf = vim.fn.bufadd "temaladda.lua"
vim.api.nvim_open_win(buf, false, {relative='win', width=50, height=10, row=5, col=40, style="minimal"})
