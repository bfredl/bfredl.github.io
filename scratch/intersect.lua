local a = vim.api
local ns = a.nvim_create_namespace "intersection"
_G.a, _G.ns = a, ns

for i = 1,30 do
  a.nvim_buf_set_extmark(0, ns, 3, 0, {})
end

_G.ide = a.nvim_buf_set_extmark(0, ns, 0, 0, {end_line=6})
print(a.nvim__buf_debug_extmarks(0, {keys=true}))


