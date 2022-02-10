ns = vim.api.nvim_create_namespace 'testa'
vim.api.nvim_buf_add_highlight(0, ns, 'ErrorMsg', 1, 5, 10)
vim.api.nvim_buf_add_highlight(0, ns, 'ErrorMsg', 2, 10, 15)
