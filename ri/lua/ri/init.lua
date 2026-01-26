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
-- extui {{{
require('vim._extui').enable {
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    target = 'cmd',
    timeout = 4000, -- Time a message is visible in the message window.
  },
}

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
