-- logic: first_run, setup module and _G {{{
local first_run = not _G.bfredl
local h = _G.bfredl or {}
-- TODO(bfredl):: _G.h should be shorthand for the _last_ edited/reloaded .lua module
_G.h = bfredl

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


-- }}}
 -- packages {{{
local packer = require'packer'
packer.init {}
packer.reset()
do each (packer.use)
  'norcalli/nvim-colorizer.lua'
  'vim-conf-live/pres.vim'
  --use 'norek/bbbork'

  'echasnovski/mini.nvim'

  'nvim-treesitter/nvim-treesitter'

  'jose-elias-alvarez/null-ls.nvim'
  'nvim-lua/plenary.nvim'

-- todo(packer): this should not be an error:
-- 'nvim-lua/plenary.nvim'

  '~/dev/nvim-miniyank'
  '~/dev/nvim-bufmngr'
  '~/dev/nvim-luadev'
  '~/dev/ibus-chords'
  '~/dev/nvim-ipy'
  '~/dev/nvim-test'
  '~/dev/vim-argclinic'
  '~/dev/nsync.nvim/'
  '~/dev/nvim-lanterna/'
  '~/dev/nvim-zigclient/'

  { '~/dev/nvim-miniluv/', rocks = 'openssl' }

  'mileszs/ack.vim'
  'saghen/blink.cmp'
  'rafamadriz/friendly-snippets'

  'phaazon/hop.nvim'
  'ggandor/leap.nvim'
  'justinmk/vim-sneak'
  'tommcdo/vim-exchange'

-- tpope section
  'tpope/vim-repeat'
  'tpope/vim-surround'
  'tpope/vim-fugitive'

  'lewis6991/gitsigns.nvim'
  'hotwatermorning/auto-git-diff'

  'vim-scripts/a.vim'
  -- {'folke/noice.nvim', requires ={'MunifTanjim/nui.nvim', "rcarriga/nvim-notify"}}

-- filetypes
  -- 'numirias/semshi'
  -- {'davidhalter/jedi-vim', ft = {'python'}}

  'ziglang/zig.vim'

  'JuliaEditorSupport/julia-vim'

  'elkasztano/nushell-syntax-vim'

  'lervag/vimtex'

-- them colors
  'morhetz/gruvbox'
  'eemed/sitruuna.vim'
end

vim.cmd [[ noremap ø :update<cr>:so $MYVIMRC<cr>:PackerUpdate<cr>  ]] -- <Plug>ch:,r

-- }}}
-- utils and API shortcuts {{{
for k,v in pairs(require'bfredl.util') do h[k] = v end
local a, buf, win, tabpage = h.a, h.buf, h.win, h.tabpage
_G.a = a

_G.__devcolors = not not (os.getenv'NVIM_DEV' and not os.getenv'NVIM_COLORDEV')

local v, set = vim.cmd, h.set
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

'belloff' ""

'linebreak'

'incsearch'
'mouse' "a"
'updatetime' (1666)
'foldmethod' "marker"
'nomodeline'

'noshowmode'

'splitbelow'

'notimeout'
'ttimeout'
'ttimeoutlen' (10)

v 'set cpo-=_'
v 'set diffopt+=vertical,linematch:60'

if first_run then
  -- I liked this better:
  vim.o.dir = '.,'..vim.o.dir
end

-- }}}
-- autocmds {{{
h.augrp = a.create_augroup("bfredl_lua", { clear=true })
function h.aucmd(event, pat, cb)
  a.create_autocmd(event, { group = h.augrp, pattern = pat, callback = cb });
end
-- }}}
-- them basic bindings {{{

-- CURRY NAM NAM, CURRY CURRY NAM NAM
function h.mapmode(mode)
  return function(lhs)
    return function(rhs)
      return a.set_keymap(mode, lhs, rhs, {})
    end
  end
end

local map = h.mapmode ''
local imap = h.mapmode 'i'
local chmap = function(x) return map('<Plug>ch:'..x) end
local CHmap = function(x) return map('<Plug>CH:'..x) end

-- test
chmap 'mw' '<cmd>lua print "HAJ!"<cr>'

chmap 'in' '<cmd>Inspect<cr>' -- LORD inspector

vim.g.surround_no_insert_mappings = 1 -- NIIIIN

-- TODO(bfredl): reload all the filetypes when reloading bfred/init.lua
v [[
  augroup bfredlft
    au FileType lua noremap <buffer> <Plug>ch:,l <cmd>update<cr><cmd>luafile %<cr>
  augroup END
]]

-- }}}
-- hop.nvim {{{
require'hop'.setup {
  keys = [[aoeipcrgljkwbmuhfqvxyzdtns]];
}
chmap 'jh' '<cmd>HopLineAC<cr>'
chmap 'kh' '<cmd>HopLineBC<cr>'
chmap 'jw' '<cmd>HopWordAC<cr>'
chmap 'kw' '<cmd>HopWordBC<cr>'
-- }}}
-- is of no SPEL {{{
chmap 'js' ']s'
chmap 'ks' '[s'
-- fix spel
chmap 'es' 'z='
-- }}}
-- git signs {{{
require('gitsigns').setup {
   current_line_blame_formatter = '  <author_time:%Y-%m-%d> - <summary>, <author>',
}
chmap 'tn' '<cmd>Gitsigns next_hunk<cr>'
CHmap 'tn' '<cmd>Gitsigns prev_hunk<cr>'
chmap 'og' ':<c-u>Gitsigns toggle<c-z>'
-- }}}
-- iimenter stuff {{{
function h.vimenter(startup)
  if startup then
    if jit then
      require'colorizer'.setup()
    end
    if a._fork_serve then
      _G.prepfork = true
       a._fork_serve()
      _G.postfork = true
       -- because reasons
       a._stupid_test()
    end
  end
end -- }}}
-- snippets {{{
if vim.snippet then
  vim.keymap.set({'i', 's'}, '<c-k>', function()
    if vim.snippet.active {direction = 1} then
      return '<cmd>lua vim.snippet.jump(1)<cr>'
    else
      return '<c-k>'
    end
  end, {expr=true})
  vim.keymap.set({'i', 's'}, '<c-j>', "v:lua.vim.snippet.jumpable(-1) ? '<cmd>lua vim.snippet.jump(1)<cr>' : '<c-j>'", {expr=true})
  require'bfredl.snippets'.setup(h)
end

do local ns = a.create_namespace 'selekt-color'
  a.set_hl(ns, "Visual", {bg='#006600'})
  local function on_win(_, winid, bufnr, row)
    if winid == a.get_current_win() and ({s=true,S=true,['']=true})[vim.fn.mode():sub(1,1)] then
      a.set_hl_ns_fast(ns)
    else
      --(a._set_hl_ns or a.set_hl_ns)(0)
    end
  end
  vim.api.nvim_set_decoration_provider(ns, {on_win=on_win})
end
-- }}}
-- LSP {{{
function h.root_pattern(pat)
  return vim.fs.dirname(vim.fs.find(pat, { upward = true })[1])
end
function h.client_capabilities(over)
  return vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), over)
end

h.clangd_path = "/home/bfredl/local/llvm17-release/bin/clangd"
function h.clangd()
  vim.lsp.start {
    name = 'clangd';
    cmd = {h.clangd_path, '-query-driver=/home/bfredl/dev/DelugeFirmware/toolchain/v16/linux-x86_64/arm-none-eabi-gcc/bin/arm-none-eabi-*'};
    root_dir = h.root_pattern {
      'compile_commands.json';
      'compile_flags.txt';
      '.clangd';
      '.git';
    };
    capabilities = h.client_capabilities {
      textDocument = {
        completion = { editsNearCursor = true; };
      };
      offsetEncoding = { 'utf-8', 'utf-16' };
      positionEncodings = { 'utf-8', 'utf-16' }; -- electric boogalo
    }
   }
end

function h.luals()
  vim.lsp.start {
    name = 'luaLS';
    cmd = {'lua-language-server'};
    root_dir = h.root_pattern {
      '.git';
      '.luarc.json';
      '.luarc.jsonc';
    };
    capabilities = h.client_capabilities {
    };
    on_init = function(client)
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = { version = 'LuaJIT'; };
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false;
            library = {
              vim.env.VIMRUNTIME;
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            };
          };
        };
      })
    end;
  }
end

if not vim.g.bfredl_nolsp then
  local has_clangd = vim.fn.executable(h.clangd_path) ~= 0
  if not has_clangd then
    h.clangd_path = "clangd"
    has_clangd = vim.fn.executable(h.clangd_path) ~= 0
  end
  if has_clangd then
    h.aucmd('FileType', {'c', 'cpp'}, function() h.clangd() end)
  end
  if vim.fn.executable('typescript-language-server') ~= 0 then
    h.aucmd('FileType', {'javascript', 'typescript'}, function() 
      vim.lsp.start {
        name = 'tsserver';
        cmd = {'typescript-language-server', '--stdio'};
        root_dir = h.root_pattern { '.git'; };
      }
    end)
  end
  if vim.fn.executable('zls') ~= 0 then
  end
  if vim.fn.executable 'jedi-language-server' ~= 0 then
  end
  if vim.fn.executable 'lua-language-server' ~= 0 then
    h.aucmd('FileType', {'lua'}, function()
      h.luals()
    end)
  end
  if vim.fn.executable('pylsp') ~= 0 then
    h.aucmd('FileType', {'python'}, function()
     vim.lsp.start {
        name = 'pylsp';
        cmd = {'pylsp'};
        root_dir = h.root_pattern { '.git'; 'setup.py'; };
      }
    end)
  end
end

h.aucmd({'BufRead','BufNewFile'}, '*.h', function()
  if string.match(a.buf_get_name(0), 'DelugeFirmware') then
    vim.cmd 'setfiletype cpp'
  else
    vim.bo.filetype = 'c'
  end
end)

a.create_user_command('ZigScope', function() require'bfredl.zigscope'.zigscope() end, {})

vim.diagnostic.config {
  signs = false;
  update_in_insert = true;
  virtual_text = {
    spacing = 2;
  }
}
-- }}}
-- tree sitter stuff {{{
function h.ts_setup()
  if os.getenv'NVIM_NOTS' then
    return
  end
  h.did_ts = true
  if true then require'nvim-treesitter.configs'.setup {
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
  } end
  v [[
   " nmap <plug>ch:ht grn
  ]]
end
if true or h.did_ts then
  h.ts_setup()
end
-- }}}
-- telescope {{{
  --
require('mini.pick').setup()
chmap 'mw' '<cmd>lua print "HAJ!"<cr>'
chmap '.u' '<cmd>Pick buffers<cr>'
CHmap '.u' '<cmd>Pick files<cr>'
chmap 'ig' '<cmd>Pick grep_live<cr>'
--chmap 'uc' '<cmd>Telescope current_buffer_fuzzy_find<cr>'
-- chmap 'am' ':Telescope <c-z>'
--chmap 'cr' '<cmd>Telescope find_files cwd=~/config2/<cr>'

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
-- statusline {{{
  --
local function stl_active()
  local MiniStatusline = require'mini.statusline'
  local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
  -- local git           = MiniStatusline.section_git({ trunc_width = 40 })
  local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
  local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
  local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
  local filename      = MiniStatusline.section_filename({ trunc_width = 500 })  -- bigly width forces relative:p
  local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
  -- local location      = MiniStatusline.section_location({ trunc_width = 75 })
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
    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
    -- { hl = mode_hl,                  strings = { search, location } },
  })
end
local function stl_inactive() return '%#MiniStatuslineInactive#%f%=' end

require'mini.statusline'.setup { content = { active = stl_active ,  inactive = stl_inactive} }
if os.getenv'NVIM_INSTANCE' then
end
-- }}}
h.f = require'bfredl.floaty'.f
_G.f = h.f -- HAIII
if os.getenv'NVIM_INSTANCE' and not __devcolors then -- {{{
  v [[ color sitruuna_bfredl ]]
else
  v [[ hi MsgArea blend=15 guibg=#281811]]
end -- }}}
v [[ hi MiniStatuslineModeInsert guibg=#DDAA22]]
v [[ hi MiniStatuslineModeCommand guibg=#22CCCC]]
v [[ hi MiniStatuslineModeVisual guibg=#606870 guifg=fg]]
return h
