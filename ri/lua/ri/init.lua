--  {{{ リ
local first_run = not _G.ri
local ri = _G.ri or {}
_G.ri = ri

local a = vim.api
_G.a = vim.api
-- }}}

function ri.on_enter(startup)
  _G._did_enter = true
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
rtp_add '~/dev/nvim-miniyank/'

-- TODO: "maybe_local" abstraction. use ~/dev/nvim-luadev if present, otherwise gh'bfredl/nvim-luadev'

-- }}}
-- options {{{
vim.o.title = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitbelow = true

vim.o.foldmethod = 'marker'
if first_run then
  -- I liked this better:
  vim.o.dir = '.,'..vim.o.dir
end
-- }}}
-- mappings {{{
function ri.mapmode(mode)
  return function(lhs)
    return function(rhs)
      return a.nvim_set_keymap(mode, lhs, rhs, {noremap=true})
    end
  end
end

vim.g.mapleader = ','

local map = ri.mapmode ''
local imap = ri.mapmode 'i'
local chmap = function(x) return map('<Plug>ch:'..x) end
local CHmap = function(x) return map('<Plug>CH:'..x) end

chmap 'in' '<cmd>Inspect<cr>' -- LORD inspector
-- TODO(ri): this is handy during construction, but I want ri/filetype.lua thing!
vim.cmd [[
  augroup bfredlft
    au FileType lua noremap <buffer> <Plug>ch:,l <cmd>update<cr><cmd>luafile %<cr>
  augroup END
]]

-- paths files, and stuff
chmap 'ph' ':cd %:p:h<cr>'
CHmap 'ph' ':cd ..<cr>'

-- window navigation
map '<Leader>o' '<C-W>o'
chmap 'hc' '<C-W>w'
CHmap 'hc' '<C-W>W'

map '<Leader>s' ':sp<CR>:bn<CR>'

-- clipboard and miniyank
map 'p' '<Plug>(miniyank-autoput)'
map 'P' '<Plug>(miniyank-autoPut)'
map '<Leader>t' '<Plug>(miniyank-startput)'
map '<Leader>T' '<Plug>(miniyank-startPut)'
chmap '.p' '<Plug>(miniyank-cycle)'
CHmap 'ao' '<Plug>(miniyank-cycleback)'
map '<Leader>C' '<Plug>(miniyank-cycle)'
map '<Leader>b' '<Plug>(miniyank-toblock)'
map '<Leader>l' '<Plug>(miniyank-toline)'
map '<Leader>k' '<Plug>(miniyank-tochar)'

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
