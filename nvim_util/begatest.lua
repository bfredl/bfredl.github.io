local ffi = require'ffi'

vim.cmd 'edit file_under_test.txt'

ffi.cdef [[
  char * ml_get(int num);
]]

local siz = vim.api.nvim_buf_line_count(0)

for j = 1, 20 do
  for i = 1, siz do
    ffi.C.ml_get(i)
  end
end
