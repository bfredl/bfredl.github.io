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

local h = bfredl

-- TODO(bfredl):: _G.h should be shorthand for the _last_ edited/reloaded .lua module
_G.h = bfredl
-- }}}
 -- packages {{{
local packer = require'packer'
packer.init {}
packer.reset()
local function packagedef()
  local use = packer.use

  use 'norcalli/snippets.nvim'
  use 'norcalli/nvim-colorizer.lua'
  use 'vim-conf-live/pres.vim'
  --use 'norek/bbbork'

  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-treesitter/playground'

  use 'neovim/nvim-lspconfig'

  use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}}

  if false then use {
    'glepnir/galaxyline.nvim', branch = 'main',
    -- your statusline
    --config = function() require'my_statusline' end,
    -- some optional icons
    ---requires = {'kyazdani42/nvim-web-devicons', opt = true}
  } end

  -- TODO(packer): this should not be an error:
  -- use 'nvim-lua/plenary.nvim'

  use '~/dev/nvim-miniyank'
  use '~/dev/nvim-bufmngr'
  use '~/dev/nvim-luadev'
  use '~/dev/ibus-chords'
  use '~/dev/nvim-ipy'
  use '~/dev/vim-argclinic'
  use '~/dev/nsync.nvim/'

  use 'mileszs/ack.vim'

  use 'Lokaltog/vim-easymotion'
  use 'justinmk/vim-sneak'
  use 'tommcdo/vim-exchange'

  -- tpope section
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'

  use 'airblade/vim-gitgutter'

  use 'vim-scripts/a.vim'

  -- filetypes
  use 'numirias/semshi'
  use {'davidhalter/jedi-vim', ft = {'python'}}

  use 'ziglang/zig.vim'

  use 'JuliaEditorSupport/julia-vim'
end
packagedef()

-- }}}
-- utils and API shortcuts {{{

h.counter = h.counter or 0
function h.id()
  h.counter = h.counter + 1
  return h.counter
end

for k,v in pairs(require'bfredl.util') do h[k] = v end
local a, buf, win, tabpage = h.a, h.buf, h.win, h.tabpage

local v = vim.cmd
local exec = h.exec
-- }}}
-- them basic bindings {{{
-- test
v [[map <Plug>ch:mw <cmd>lua print("howdy")<cr>]]

-- TODO(bfredl): reload all the filetypes when reloading bfred/init.lua
v [[
  augroup bfredlft
    au FileType lua noremap <Plug>ch:,l <cmd>update<cr><cmd>luafile %<cr>
    au FileType lua noremap <Plug>ch:un <cmd>update<cr><cmd>luafile %<cr>
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
