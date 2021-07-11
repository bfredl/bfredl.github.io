local winh = nil
local bufh = nil
local chan = nil

vim.cmd("vsplit")
winh = vim.api.nvim_get_current_win()
bufh = vim.api.nvim_create_buf(true, true)
vim.api.nvim_win_set_buf(winh, bufh)
vim.api.nvim_set_current_win(winh)
vim.cmd("term")
for _, c in ipairs(vim.api.nvim_list_chans()) do
    if c.buffer == bufh then
        print("setting chan to " .. c.id)
        chan = c
    end
end
vim.api.nvim_chan_send(chan.id, "ls\n")
