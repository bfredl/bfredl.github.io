local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
local ns = vim.api.nvim_create_namespace('test')

-- print the namespace id so that we can call nvim_buf_clear_namespace manually to clear everything
print('namespace', ns)

for li, line in pairs(lines) do
  for col = 1, #line, 2 do
    vim.api.nvim_buf_set_extmark(
      0,
      ns,
      li - 1,
      col - 1,
      { virt_text = {{ 'a', 'ErrorMsg'}}, virt_text_pos = 'overlay' }
    )
  end
end


