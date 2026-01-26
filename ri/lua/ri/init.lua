--  {{{ リ
local first_run = not _G.ri
local ri = _G.ri or {}
_G.ri = ri -- }}}

function ri.on_enter(startup)
  _G.ari = true
end

-- packages {{{
vim.pack.add {
  'https://github.com/nvim-mini/mini.nvim';
}
-- }}}
-- mini {{{
require'mini.statusline'.setup {}
-- }}}
-- epilogue {{{
if first_run then
  vim.cmd [[autocmd VimEnter * lua _G.ri.on_enter(true)]]
else
  -- already dunnit, so fake it on reload
  ri.on_enter(false)
end

return ri
-- }}}
