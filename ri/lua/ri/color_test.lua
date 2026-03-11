 local p = require('mini.base16').mini_palette('#151522', '#dee2f1', 65)

 vim.cmd 'hi clear'

require'mini.base16'.setup {
	palette = p;
}

vim.api.nvim_set_hl(0, '@lsp.type.macro', {})
vim.api.nvim_set_hl(0, '@constructor.lua', {})
vim.api.nvim_set_hl(0, 'Delimiter', {})


--require('mini.colors').interactive()

