local buf1 = vim.api.nvim_create_buf(false, true)
local lines1 = { 'aaa', 'bbb', 'ccc' }
vim.api.nvim_buf_set_lines(buf1, 0, -1, true, lines1)

local buf2 = vim.api.nvim_create_buf(false, true)
local lines2 = {}
vim.api.nvim_buf_set_lines(buf2, 0, -1, true, lines2)

vim.print(vim.api.nvim_buf_get_lines(buf1, 0, -1, true))
