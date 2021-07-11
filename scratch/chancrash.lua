vim.cmd [[:set number]]

-- Paste into buffer and run with :luafile %
local buf_id = vim.api.nvim_create_buf(true, true)
vim.api.nvim_win_set_option(0, "number", false)
local chan_id = vim.api.nvim_open_term(buf_id, {})
local line = "a"
local lines = {}
for i=0,80,1 do
   table.insert(lines, line)
end
vim.fn.chansend(chan_id, lines)
vim.api.nvim_win_set_buf(0, buf_id)
