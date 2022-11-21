local opts = {
  relative = "editor",
  width = vim.o.columns,
  height = 10,
  focusable = false,
  anchor = "SW",
  border = "single",
  row = vim.o.lines - 2 - vim.o.cmdheight + 1,
  col = 0,
  style = "minimal",
  noautocmd = true,
}

local M = {}

M.buf = vim.api.nvim_create_buf(false, true)
M.win = vim.api.nvim_open_win(M.buf, false, opts)

vim.api.nvim_buf_set_option(M.buf, "bufhidden", "wipe")

vim.cmd([[hi FooBar guibg=#ff007c guifg=white]])
vim.api.nvim_win_set_option(M.win, "winhighlight", "NormalFloat:FooBar,FloatBorder:FooBar")

vim.api.nvim_win_set_height(M.win, 10)
vim.cmd([[redraw]])

vim.api.nvim_win_set_height(M.win, 5)
vim.api.nvim_echo({ { "" } }, false, {})
vim.cmd([[redraw]])

vim.fn.getchar()
vim.api.nvim_win_close(M.win, true)
