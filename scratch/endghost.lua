ns = vim.api.nvim_create_namespace 'raaa'
vim.api.nvim_buf_set_extmark(1, ns, 1,0, {virt_lines_above=false, virt_lines_leftcol=false, virt_lines={ {{'this is\tvery much', 'String'}}}, end_col=0})


vim.api.nvim_buf_clear_namespace(1, ns, 0, -1)

