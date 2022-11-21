-- lord inspector lord inspector

-- lord inspector lord inspector
local a = vim.api
local ns = a.nvim_create_namespace "aaa"
_G.ns = ns

for i = 1,10 do
  a.nvim_buf_set_extmark(0, ns, 0, i, {end_line=2, end_col=i})
end
if false then
  i = 10
  vim.loop.kill(vim.fn.getpid(), 5)
  a.nvim_buf_set_extmark(0, ns, 0, i, {end_line=2, end_col=i})
end

a.nvim__buf_intersect(0, 1, 1)
a.nvim__buf_debug_extmarks(0, {keys=true})
