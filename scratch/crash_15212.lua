local ns = vim.api.nvim_create_namespace("myplugin")
vim.api.nvim_buf_set_extmark(0, ns, 0, 0, {virt_text = {{"a"}}, end_col = 0})
vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
vim.cmd("bdelete")


