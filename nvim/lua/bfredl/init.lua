-- logic: first_run, setup module and _G {{{
local first_run = not _G.bfredl
local bfredl = _G.bfredl or {}

if not first_run then
  require'plenary.reload'.reload_module'bfredl.'
end

do local status, err = pcall(vim.cmd, [[ runtime! autoload/bfredl.vim ]])
  if not status then
    vim.api.nvim_err_writeln(err)
  end
end

local function each(z)
  return (function (x) return x(x) end) (function (x) return function (y) z(y) return x(x) end end)
end

local h = bfredl

-- TODO(bfredl):: _G.h should be shorthand for the _last_ edited/reloaded .lua module
_G.h = bfredl
-- }}}
 -- packages {{{
local packer = require'packer'
packer.init {}
packer.reset()
do each (packer.use)
  'norcalli/snippets.nvim'
  'norcalli/nvim-colorizer.lua'
  'vim-conf-live/pres.vim'
  --use 'norek/bbbork'


  'nvim-treesitter/nvim-treesitter'
  'nvim-treesitter/playground'

  'neovim/nvim-lspconfig'

  {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}}

-- TODO(packer): this should not be an error:
-- use 'nvim-lua/plenary.nvim'

  '~/dev/nvim-miniyank'
  '~/dev/nvim-bufmngr'
  '~/dev/nvim-luadev'
  '~/dev/ibus-chords'
  '~/dev/nvim-ipy'
  '~/dev/vim-argclinic'
  '~/dev/nsync.nvim/'

  { '~/dev/nvim-miniluv/', rocks = 'openssl' }

  'mileszs/ack.vim'

  'Lokaltog/vim-easymotion'
  'justinmk/vim-sneak'
  'tommcdo/vim-exchange'

-- tpope section
  'tpope/vim-repeat'
  'tpope/vim-surround'
  'tpope/vim-fugitive'

  'airblade/vim-gitgutter'

  'vim-scripts/a.vim'

-- filetypes
  'numirias/semshi'
  {'davidhalter/jedi-vim', ft = {'python'}}

  'ziglang/zig.vim'

  'JuliaEditorSupport/julia-vim'

end

-- }}}
-- utils and API shortcuts {{{
for k,v in pairs(require'bfredl.util') do h[k] = v end
local a, buf, win, tabpage = h.a, h.buf, h.win, h.tabpage
_G.a = a

local v, exec, set = vim.cmd, h.exec, h.set
-- }}}
-- basic options {{{
'hidden'
'title'
'number'
'smartcase'
'ignorecase'
'expandtab'
'sw' (2)
'ts' (2)
'sts' (2)

'incsearch'
'mouse' "a"
'updatetime' (1666)
'foldmethod' "marker"
'nomodeline'

'splitbelow'

'notimeout'
'ttimeout'
'ttimeoutlen' (10)

v 'set cpo-=_'
v 'set diffopt+=vertical'

if first_run then
  -- I liked this better:
  vim.o.dir = '.,'..vim.o.dir
end

-- }}}
-- them basic bindings {{{
-- test
v [[map <Plug>ch:mw <cmd>lua print("howdy")<cr>]]

-- TODO(bfredl): reload all the filetypes when reloading bfred/init.lua
v [[
  augroup bfredlft
    au FileType lua noremap <buffer> <Plug>ch:,l <cmd>update<cr><cmd>luafile %<cr>
  augroup END
]]

-- }}}
-- vimenter stuff {{{
function h.vimenter(startup)
  if startup then
    require'colorizer'.setup()
    if a._fork_serve then
      _G.prepfork = true
       a._fork_serve()
      _G.postfork = true
       -- because reasons
       a._stupid_test()
    end
  end
end -- }}}
require'bfredl.snippets'.setup()
-- LSP {{{
if not vim.g.bfredl_unvisual then
  if vim.fn.executable('clangd') ~= 0 then
    require'lspconfig'.clangd.setup {}
  end
  if vim.fn.executable('ra_lsp_server') ~= 0 then
    require'lspconfig'.rust_analyzer.setup {}
  end
  if vim.fn.executable('zls') ~= 0 then
    require'lspconfig'.zls.setup {}
  end
end
-- }}}
-- tree sitter stuff {{{
function h.ts_setup()
  h.did_ts = true
  require'nvim-treesitter.configs'.setup {
    --ensure_installed = "all",     -- one of "all", "language", or a list of languages
    highlight = {
      enable = true; -- false will disable the whole extension
    };
    incremental_selection = {
      enable = true;
      keymaps = {
        init_selection = "gnn";
        node_incremental = "gxn";
        scope_incremental = "grc";
        node_decremental = "grm";
      };
    };
    refactor = {
      highlight_definitions = { enable = true };
      --highlight_current_scope = { enable = false };
    };
    playground = {
      enable = true;
      disable = {};
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source cod;
      persist_queries = false; -- Whether the query persists across vim sessions
    };
  }
  v [[
    nmap <plug>ch:ht grn
  ]]
end
if true or h.did_ts then
  h.ts_setup()
end
-- }}}
-- color {{{

local colors = require'bfredl.colors'
h.colors = colors
if os.getenv'NVIM_INSTANCE' then
  colors.defaults()
else
  v [[ hi EndOfBuffer guibg=#222222 guifg=#666666 ]]
  v [[ hi Folded guifg=#000000 ]]
end

function h.xcolor()
 local out = io.popen("xcolor"):read("*a")
 return vim.trim(out)
end
v 'inoremap <F3> <c-r>=v:lua.bfredl.init.xcolor()<cr>'
-- }}}
require'bfredl.miniline'.setup()
h.f = require'bfredl.floaty'.f
_G.f = h.f -- HAIII
-- autocmds {{{
exec [[
  augroup bfredlua
  augroup END
]]
-- }}}
return bfredl
