ns = vim.api.nvim_create_namespace 'buff'
vim.api.nvim_buf_set_extmark(0, ns, 3, 4, {virt_text={{'>>', 'ErrorMsg'}}, virt_text_pos='inline', right_gravity=false})
vim.api.nvim_buf_set_extmark(0, ns, 3, 4, {virt_text={{'<<', 'ErrorMsg'}}, virt_text_pos='inline', right_gravity=true})
-- [] text here
