local bufnr = vim.api.nvim_create_buf(false, true)
local winid = vim.api.nvim_open_win(bufnr, true, {
  width = 50,
  height = 2,
  relative = 'cursor',
  row = 5,
  col = 22,
  border = "double",
})

vim.api.nvim_win_set_option(winid, "winhl", "Normal:TestNormal")
