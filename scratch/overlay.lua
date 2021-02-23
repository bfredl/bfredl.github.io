ns = vim.api.nvim_create_namespace'aaa'
if true then
  x = 3
end

id = vim.api.nvim_buf_set_extmark(0, ns, 2, 0, { virt_text={{'--', 'ErrorMsg'}, {'gg', 'String'}}, virt_text_style='overlay'})

