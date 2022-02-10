ns = vim.api.nvim_create_namespace'est'
vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
vim.cmd [[
  hi Aaaa guibg=Blue
  hi Bbbb guifg=Orange
]]
vim.api.nvim_buf_set_extmark(0, ns, 0, 5, {
  virt_text={{'helloo', {'Aaaa', 'Bbbb'}}},
  virt_text_pos='overlay'})
