--  {{{ リ
local first_run = not _G.ri
local ri = _G.ri or {}
_G.ri = ri -- }}}

function ri.on_enter(startup)
  _G.ari = true
end

-- packages {{{
local gh = function(x) return 'https://github.com/' .. x end
local cb = function(x) return 'https://codeberg.org/' .. x end

vim.pack.add {
  gh 'nvim-mini/mini.nvim';
}

local rtp_add = function(x) vim.o.rtp = vim.o.rtp ..','.. x end
-- TODO: rework ibus-chords to use lzmq ffi!
-- also more like a proper lua plugin..
rtp_add '~/dev/ibus-chords'

-- TODO: "maybe_local" abstraction. use ~/dev/nvim-luadev if present, otherwise gh'bfredl/nvim-luadev'

-- }}}
-- options {{{
vim.o.ignorecase = true
vim.o.smartcase = true
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
