local v = vim.api
local buf

local function popup()
  buf = v.nvim_create_buf(false, true)
  for _ = 1,5000 do
    local id = v.nvim_open_win(buf, false, {relative = "cursor", width = 5, height = 1, col = 0, row = -1, focusable = false, style = "minimal"})
    v.nvim_win_close(id, false)
  end
end

popup()
