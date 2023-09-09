local buf_id = vim.api.nvim_create_buf(false, true)
local win_id = vim.api.nvim_open_win(
  buf_id,
  false,
  { relative = 'editor', row = 1, col = 1, width = 10, height = 4, style = 'minimal', border = 'single' }
)

local timer = vim.loop.new_timer()
local win_update = vim.schedule_wrap(function()
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, true, vim.split('abcdefg', ''))
  vim.cmd('redraw')
end)

while true do
  timer:start(0, 0, win_update)
  local ok, key = pcall(vim.fn.getcharstr)
  timer:stop()
  if not ok or key == '\27' then break end
  vim.api.nvim_win_call(win_id, function() vim.cmd('normal! ' .. key) end)
end

vim.api.nvim_win_close(win_id, true)
