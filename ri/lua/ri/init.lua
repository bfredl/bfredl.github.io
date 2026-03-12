--  {{{ リ
local first_run = not _G.ri
local ri = _G.ri or {}
_G.ri = ri

local a = vim.api
_G.a = vim.api

if not first_run then
  for pack, _ in pairs(package.loaded) do
    if vim.startswith(pack, 'ri.') then
      package.loaded[pack] = nil
    end
  end
end
-- }}}

function ri.on_enter(startup)
  _G._did_enter = true
end

ri.augroup = vim.api.nvim_create_augroup("RiMainAutocmds", { clear = true })
local function aucmd(which, opts)
  opts.group = ri.augroup
  return vim.api.nvim_create_autocmd(which, opts)
end


-- packages {{{
local gh = function(x) return 'https://github.com/' .. x end
local cb = function(x) return 'https://codeberg.org/' .. x end

vim.pack.add {
  gh 'nvim-mini/mini.nvim';
  gh 'lewis6991/gitsigns.nvim';
  gh 'nvim-treesitter/nvim-treesitter';
}

local rtp_add = function(x) vim.o.rtp = vim.o.rtp ..','.. x end
-- TODO: rework ibus-chords to use lzmq ffi!
-- also more like a proper lua plugin..
rtp_add '~/dev/ibus-chords'
rtp_add '~/dev/nvim-miniyank/'
rtp_add '~/dev/nvim-luadev'

-- TODO: "maybe_local" abstraction. use ~/dev/nvim-luadev if present, otherwise gh'bfredl/nvim-luadev'

-- }}}
-- options {{{
vim.o.title = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitbelow = true

vim.o.timeout = false
vim.o.ttimeout = true
vim.o.ttimeoutlen = 10

vim.o.foldmethod = 'marker'
if first_run then
  -- I liked this better:
  vim.o.dir = '.,'..vim.o.dir
end

vim.o.termguicolors = true
vim.o.winblend = 20
vim.o.pumblend = 20

vim.o.list = true
vim.o.listchars='tab:▸ ,extends:❯,precedes:❮,trail:█'
vim.o.fillchars='eob:█'
vim.o.showbreak='↪'

-- TODO: sane way for reloading. just for updating the global defaults or for resseting curbuf?
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2

-- easy!
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

-- cmdline/wildmode
vim.o.wildmenu = true
vim.o.wildmode = 'longest:full,full'
vim.o.wildignorecase = true

-- diagostics

vim.diagnostic.config {
  signs = false;
  update_in_insert = true;
  virtual_text = {
    spacing = 2;
  }
}
-- }}}

-- half baked. the idea is that we will use mini.colors to "freeze" a goodenoughly config eventually
require'ri.color_test'

local hipatterns = require'mini.hipatterns'
hipatterns.setup {highlighters = {hex_color = hipatterns.gen_highlighter.hex_color()}}

-- mappings {{{
function ri.mapmode(mode)
  return function(lhs)
    return function(rhs)
      return a.nvim_set_keymap(mode, lhs, rhs, {noremap=true})
    end
  end
end
local function emap(mode, lhs, rhs)
  return a.nvim_set_keymap(mode, lhs, '', {noremap=true, expr=true, replace_keycodes=true, callback=rhs})
end

vim.g.mapleader = ','

local map = ri.mapmode ''
local imap = ri.mapmode 'i'
local cmap = ri.mapmode 'c'
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
chmap ',.' '"+y'
CHmap ',.' '"+yy'
chmap 'jk' '"*y'
CHmap 'jk' '"*yy'
map '<Leader>p' '"+p'
map '<Leader>P' '"+P'
map '<Leader>i' '"*p'
map '<Leader>I' '"*P'

chmap 'it' "'[=']"
CHmap 'it' "'[V']"
-- ch:,u
map 'ü' [["*p'[V']>.]]

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

-- errorlist

chmap 'ag' ':silent grep '
aucmd("QuickFixCmdPost", { pattern = { "grep" }, command = "cwindow" })

chmap 'jc' '<cmd>cnext<cr>'
chmap 'kc' '<cmd>cprev<cr>'
chmap 'jn' '<cmd>lnext<cr>'
chmap 'kn' '<cmd>lprev<cr>'

-- general movement

chmap 'jt' 'gj'
chmap 'kt' 'gk'
chmap 'hn' '<cmd>noh<cr>'

-- macro
map '<leader>c' '@q'

-- insert completion
vim.o.completeopt = "menuone,preview,longest"
emap('i', '<tab>', function()
  local complete = false
  if vim.fn.pumvisible() > 0 then
    complete = true
  else
    local ch = vim.fn.matchstr(a.nvim_get_current_line(), '\\%' .. (vim.fn.col('.')-1) .. 'c.')
    complete = ch ~= "" and ch ~= " " and ch ~= "\t"
  end
  return (complete and "<c-n>") or "<tab>"
end)

-- cmdline
emap('c', '/', function()
  if vim.fn.wildmenumode() == 1 then
    return (vim.endswith(vim.fn.getcmdline(), '/') and '<bs>' or '')..'/<c-z>'
  end
  return '/'
end)

-- config by itself
function ri.rt(name)
  return a.nvim_get_runtime_file(name, 0)[1]
end
vim.cmd'command! Reload luafile $MYVIMRC'
-- TODO(ri): jump to open window if already exist
map '<leader>h' ('<cmd>split '..ri.rt('lua/ri/init.lua')..'<cr>')
-- TODO(ri): this might break when buffer was loaded via absolute path and not
-- using the symlink which is part of runtimepath
aucmd("BufWritePost", { pattern = { ri.rt('lua/ri/init.lua') }, command = "Reload" })

-- }}}

if false then aucmd({'BufRead','BufNewFile'}, '*.h', function()
  if string.match(a.buf_get_name(0), 'DelugeFirmware') then
    vim.cmd 'setfiletype cpp'
  else
    vim.bo.filetype = 'c'
  end
end) end

require'ri.chainfire'
-- mini.statusline {{{
local function stl_active()
  local MiniStatusline = require'mini.statusline'
  local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
  -- local git           = MiniStatusline.section_git({ trunc_width = 40 })
  local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
  local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
  local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
  local filename      = MiniStatusline.section_filename({ trunc_width = 500 })  -- bigly width forces relative:p
  local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
  --local location      = MiniStatusline.section_location({ trunc_width = 75 })
  local section_location = function(args)
    -- Use virtual column number to allow update when past last column
    if MiniStatusline.is_truncated(args.trunc_width) then return '%l│%2v' end

    -- Use `virtcol()` to correctly handle multi-byte characters
    -- ååe
    return '%l|%L│%2c%2V|%-2{virtcol("$") - 1}'
  end

  local location      = section_location({ trunc_width = 75 })
  -- local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

  if mode == "Command" then
    mode = "C-line"
  elseif mode == "V-Block" then
    mode = "V-Blck"
  end

  return MiniStatusline.combine_groups({
    { hl = mode_hl,                  strings = { mode } },
    { hl = 'MiniStatuslineDevinfo',  strings = { diff, diagnostics, lsp } },
    '%<', -- Mark general truncate point
    { hl = 'MiniStatuslineFilename', strings = { filename } },
    '%=', -- End left alignment
    { hl = 'MiniStatuslineFilename', strings = { location } },
    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
    -- { hl = mode_hl,                  strings = { search, location } },
  })
end
local function stl_inactive() return '%#MiniStatuslineInactive#%f%m%=' end

require'mini.statusline'.setup { content = { active = stl_active ,  inactive = stl_inactive} }
-- }}}
-- mini.pick {{{
require('mini.pick').setup()
chmap '.u' '<cmd>Pick buffers<cr>'
CHmap '.u' '<cmd>Pick files<cr>'
chmap 'ig' '<cmd>Pick grep_live<cr>'
-- }}}
-- git signs {{{
require('gitsigns').setup {
   current_line_blame_formatter = '  <author_time:%Y-%m-%d> - <summary>, <author>',
}
chmap 'tn' '<cmd>Gitsigns next_hunk<cr>'
CHmap 'tn' '<cmd>Gitsigns prev_hunk<cr>'
chmap 'og' ':<c-u>Gitsigns toggle<c-z>'
-- }}}
-- extui {{{
require'vim._core.ui2'.enable {
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    target = 'cmd',
    timeout = 4000, -- Time a message is visible in the message window.
  },
}

-- }}}
-- epilogue {{{
if first_run then
  aucmd('VimEnter', {command = 'lua _G.ri.on_enter(true)'})
else
  -- already dunnit, so fake it on reload
  ri.on_enter(false)
end

return ri
-- }}}
