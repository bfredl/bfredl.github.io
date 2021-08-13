ns = vim.api.nvim_create_namespace 'raaa'
vim.api.nvim_buf_set_extmark(1, ns, 5, 5, {virt_text_lines={{{'this is very much', 'String'}}, {{'ghostily ', 'ErrorMsg'}, {'text','LineNr'}}, }})

--[[

vim.api.nvim_buf_clear_namespace(1, ns, 0, -1)

]]
