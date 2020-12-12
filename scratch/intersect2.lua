local a = vim.api
local ns = a.nvim_create_namespace "intersection"
_G.a, _G.ns = a, ns

_G.ide = a.nvim_buf_set_extmark(0, ns, 0, 0, {end_line=6})

if true then for i = 1,3 do
    for j = 1,10 do
      a.nvim_buf_set_extmark(0, ns, 3, 0, {})
    end
  print(a.nvim__buf_debug_extmarks(0, {keys=true}))
end end


--a.nvim_set_current_line(a.nvim__buf_debug_extmarks(0, {keys=true}))

