local m = dofile'/home/bfredl/config2/nvim/lua/bfredl/moonwatch.lua'
_G.m = m
local a = bfredl.a

local sf = m.float
_G.sf = sf

local s = m.make_show("Neovim internals: past and future", _G.s)
_G.s = s

m.prepare()
m.cls()

dgreen = "#338844"
dred = "#880000"

vim.cmd [[au! lspconfig FileType c]]
vim.lsp.stop_client(vim.lsp.get_active_clients())
vim.cmd [[set shortmess+=F]]
vim.cmd [[set winblend=0]]

function arrow(args)
  local r2,c2 = args.r2 or args.r, args.c2 or args.c
  sf {r=args.r, c=args.c, bg="#aaaaaa", h = r2-args.r+1, w=c2-args.c+1}
end

function sl(args) sf (vim.tbl_extend("keep", args, {h=1, c=0})) end
function sh(args) sf (vim.tbl_extend("keep", args, {h=1, c=100, anchor='NE'})) end

s:slide("titlepage", function()
  m.header 'Neovim internals: past and future'

sl {r=5, bg="#EEEEEE", w=100}
sl {r=8, bg="#00EEEE", w=72}
sh {r=13, bg="#FF2222", w=72}
sl {r=16, bg="#00EEEE", w=72}
sh {r=18, bg="#FF2222", w=65}
sl {r=22, bg="#00EE00", w=50}
sh {r=26, bg="#9000FF", w=65}
sl {r=32, bg="#00EE00", w=55}
--sl {r=32, bg="#2222DD", w=100}

  -- IMAGEN
end)

s:slide("intro", function()
  m.header 'intro'
  sf {r=2, c=3, text=[[According to the website:]]}
  sf {r=4, text=[[
Neovim is a project that seeks to aggressively refactor Vim in order to:

- Simplify maintenance and encourage contributions
- Split the work between multiple developers
- Enable advanced UIs without modifications to the core
- Maximize extensibility
  ]], bg="#CCCCCC", fg="#000022"}
-- TODO: add highlights

  sf {r=12, w=70, c=3, text=[[
- Neovim is often compared w/vim and other editors on features
- Let's talk about the internal refactors which enables
  - maintenance of existing code
  - add more features
  ]]}
end)

s:slide("whoami", function()
  m.header 'Whoami'
  sf {r=4, w=55, text=[[
- Regular contributor to Neovim since early 2015
- Doing paid work for Neovim since this Fall.
- "One of multiple dictators like Bram" for the project
  ]]}

  -- IMAGEN

  sf {r=12, text=[[
- github.com/bfredl
  ]]}
end)

s:slide("early", function()
  m.header 'early internal refactors'
  -- TODO: make this a table or something??
  sf {r=3, text=[[First wave of refactors: maintainability]]}
  sf {r=5, w=70, text=[[
 - remove most #ifdef FEAT_XXXX
 - platform specific code -> libuv
 - multiple makefiles -> CMake
 - custom tools, macros -> lua scripts
 - multiple "script hosts" -> unified API and RPC protocol
 - TUI/GUI code in main process -> UI protocol (on top of RPC)
]]}
end)

s:slide("preevent", function()
  m.header 'event handling in vim 2014'
  local waitbuf = vim.fn.bufadd 'waitchar.c'
  sf {r=3, bg="#000033", h=25, w=70, buf=waitbuf, focusable=true}

  sf {r=29, text=[[
Note: event handling in vim8/9 has also evolved (but
      in different directions)]]}
end)


s:slide("event", function()
  m.header 'event handling'
  sf {r=8, h=8, w=72, text=[[
                        internal refactor:
    replace internal event handling and plattform support with libuv

uv_run()
uv_pipe_open()
uv_spawn()
uv_fs_*() 
  ]], bg=dgreen}
  arrow {r=14,c=35, r2=22}
  sf {r=23, c=20, h=5, text=[[
    event/os interface for lua plugins    

vim.loop.pipe()
vim.loop.spawn("subprocess")
...
  ]], bg=dred}
  sf {r=3, text=[[
 - from libuv internally to get vim.loop _plugin_ interface "for free"
]]}
end)

s:slide("ui", function()
  vim.cmd [[hi FloatBorder guibg=#770000 guifg=#DDDDDD]]
  sf {r=3, c=6, h=5, w=66, bg='FloatBorder', border='double', text=[[


      long running theme: GUI and TUI
  ]]}

  -- IMAGEN
end)

s:slide("evo", function()
  m.header 'First refactor: the UI protocol'

  sf {r=3, w=60, text=[[
Tarrudas initial redesign in 2014: 
  - move terminal and gui code out of the core thread

  - TUI runs in-process, but as a separate thread

  - external GUI:s run as separate processes
    using RPC calls and events]]}
end)

protobg = "#280055"


s:slide("evo1", function()
  vim.cmd "set wd=0 rdb="
  m.header 'Evolution of the UI protocol: initial version'
  sf {r=3, text=[[ui_attach(20,50,rgb=true) =>]]}
  sf {r=5, c=15, w=50, bg=protobg, text=[[
resize(20,50)
update_bg(0x112222)
clear()
cursor_goto(0,0)
put[('h'), ('e'), ('l'), ('l'), ('o')]
cursor_goto(1,0)
put[('w'), ('o'), ('r'), ('l'), ('d')]
cursor_goto(2,0)
highlight_set({foreground=0x0000FF, bold=true})
put[('~'), (' '), (' '), (' '), (' '), ...]
cursor_goto(3,0)
put[('~'), (' '), (' '), (' '), (' '), ...]
...
cursor_goto(0,5)
]]}

  sf {r=21, w=60, text=[[
- VT100 commands but now in msgpack (yay!)
- text is drawn at the cursor just like a terminal
- cycles of cursor_goto/highlight_set/put .. commands
  ]]}
end)

s:slide("evo2", function()
  m.header 'Evolution of the UI protocol: "linegrid"'
  vim.cmd "set wd=50 rdb=compositor"
  sf {r=3, text=[[nvim_ui_attach(20,50,{rgb=true, ext_linegrid=true}) =>]]}
  local bufid
  sf {r=5, c=15, w=55, h=11, bg=protobg, blend=0,
      fn=function() bufid = vim.api.nvim_get_current_buf() end,
      text=""}
  vim.cmd "redraw"
  vim.api.nvim_buf_set_text(bufid, 0, 0, 0, 0, vim.split([=[
grid_resize(1,20,50)
hl_attr_define(7, {foreground=0x0000FF, bold=true})
grid_clear(1)
grid_line[
  (0, 0, ['h', 'e', 'l', 'l', 'o']),
  (1, 0, ['w', 'o', 'r', 'l', 'd']),
  (2, 0, [['~', 1, 7], [' ', 49]]),
  (3, 0, [['~', 1, 7], [' ', 49]]),
]
grid_cursor_goto(1,0,5)
]=], '\n'))

  sf {r=18, w=75, text=[[
- Same contents, but now drawing text is separated from the cursor
- cached color/highlight definitions
- we are operating on grid "1"
  ]]}

  vim.cmd "redraw"

  vim.cmd "set wd=0 rdb="
end)

s:slide_multi("evo3", 5,  function(i)
  vim.cmd "set wd=0 rdb="
  m.header 'Evolution of the UI protocol: "multigrid"'
  sf {r=3, text=[[nvim_ui_attach(20,50,{rgb=true, ext_multigrid=true}) =>]]}
  sf {r=5, c=15, w=50, bg=protobg, text=[[
win_float_pos(2, 1000)
grid_resize(2,2,20)
grid_line[
-- contents of float
  
]
...]]}


  sf {r=13, w=65, text=[[
- now we can use multiple grids
- ext_multigrid: different text size per window
- floats: draw overlays like separate layers
  ]]}

if i > 1 and i <= 4 then
  sf {r=0, h=80, c=30, w=10, bg="#00cc00", blend=70, zindex=(i == 3 and 99 or 1), fn=function()
    vim.cmd [[ set winblend=70]]
  end}
end
if i > 3 then
  sf {r=18, c=05, w=50, bg="#FFFFFF", fg="#080808", text=[[set rdb=compositor wd=100]]}
end
vim.cmd "set wd=0 rdb="
if i == 4 then
  vim.cmd "set wd=100 rdb=compositor"
  vim.cmd "redraw"
end
end)

s:slide("evo4", function()
  vim.cmd "set wd=0 rdb="
  m.header 'Evolution of the UI protocol: widgets'
  sf {r=3, text=[[nvim_ui_attach(20,50,{..., ext_popupmenu=true, ext_cmdline=true}) =>]]}
  sf {r=5, c=15, w=70, bg=protobg, text=[[
grid_line(1, row, col, ["e","d"])
popupmenu_show(grid, row, col, ["edit", "editor", "edible"], 1)
popupmenu_select(2)
popupmenu_hide()
grid_line(1, row, col, ["e","d","i","t","o","r"])
]]}

  sf {r=13, w=65, text=[[
- From glorified terminal to UI components!
- popupmenu
- cmdline
- messages
- tabline
]]}

end)

s:slide("evo5", function()
  m.header 'Evolution of the UI protocol: widgets in TUI'
  vim.cmd [[hi FloatBorder guibg=#2222FF guifg=#DDDDDD]]
  vim.cmd [[hi FloatTitle guibg=#2222FF guifg=#DDDDDD]]
  sf {r=3, c=6, h=18, w=66, border='double', title='══| folke/noice.nvim |', fn=function()
    local term = vim.api.nvim_open_term(0, {})
    local ros = io.open'rosen.cat':read'*a'
    vim.api.nvim_chan_send(term, ros)
  end}

  sf {r=25, w=75, text=[[
- lua plugins can process ui widget events internally
- This approaches a lua reimplementation of the TUI based on multigrid!
]], fg="#FF0000"}
end)

s:slide("evo5b", function()
  m.header 'Evolution of the UI protocol: widgets in TUI'
  sf {r=3, h=15, w=80, text=[[trouble in paradise:

#20463: redraw doesn't update the UI during substitute

#17810: Wrong incsearch highlighting when calling nvim_buf_set_lines from timer in cmdline with conceallevel

#20416: No way to know if a message was sent because of a redraw. vim.ui_attach with ext_messages 

#20715: Formatting of msg_show for map is missing newlines with ext_messages

#20715: cmdheight=0: unsuccessful search is prompting for ENTER to continu

#21018: setting 'guicursor' to empty too quickly leads to unexpected results

Now UI implementation is back in main thread. this causes some problems
  ]]}
  -- LIST weird issues caused by noice vs event loop


  sf {r=20, text=[[
This approaches a lua reimplementation of the TUI based on multigrid!
]], fg="#FF0000"}
end)

s:slide("redraw_chain", function()
  m.header 'redrawing the ui: LAYERS'
  sf {r=3, text=[[ STACK MORE LAYERS!]]}
function box(line, c) return function(text)
  sf {r=line, c=c, bg="#1111bb", center="c", text=text}
end end
function line(at, c)
  sf {r=at, c=c, center="c", text="|"}
end
local c0 = 42
box (5,c0) [[update_screen()]]
line (6,c0)
box (7,c0) [[win_update(): 1000 lines]]
line (8,c0)
box (9,c0) [[win_line(): 2200 lines ]]
line (10,c0)
box (11,c0) [[grid_line()]]
line (12,c0)
box (13,c0) [[ui_line()]]
line (14,c0)
box (15,c0) [[ui->raw_line(ui, ...);]]
sf {r=16, c=31, text="/"}
sf {r=16, c=48, text="\\"}

local c1 = 26
box (17,c1) [[ui_comp_rawline()]]
line (18,c1)
box (19,c1) [[ui_bridge_rawline()]]
line (20,c1)
box (21,c1) [[tui_raw_line()]]

local c2 = 56
box (17,c2) [[remote_ui_raw_line()]]
line (18,c2)
box (19,c2) [[rpc_send_event()]]
line (20,c2)
box (21,c2) [[remote ui goes here]]

sf {r=25, w=60, text=[[
plan: get rid of ui_bridge and "virtual" UI in server
move TUI and perhaps also "compositor" to separate process

longer time plan: refactor andsplit up win_update/win_line
]]}
end)

if false then
s:slide("intredraw", function()
  m.header 'redrawing: internals'
  sf {r=3, w=55, text=[[
phase 1: mark redrawing as needed
redraw_win_later(win, NOT_VALID);
...

phase 2: at $PLACES, redraw all parts of the screen:
update_screen()
gui_update_screen()
update_curbuf()
update_single_line()
update_debug_sign()

win_update(): 1000 lines
win_line(): 2200 lines
]]}
end)
end

s:slide("intredraw_line", function()
  m.header 'redrawing: internals'
  -- LURING? show the vim 7.4 version with #ifdefs first?
  local winbuf = vim.fn.bufadd 'winline.c'
  sf {r=3, bg="#000033", h=25, w=70, buf=winbuf, focusable=true, fn=function()
    vim.cmd [[1]]
  end}
end)

vim.cmd [[hi MORKER  guifg=#FF0000 gui=bold]]
vim.cmd [[hi FulMetod  guifg=#33DDFF gui=NONE]]
vim.cmd [[hi BriteNumber gui=bold guifg=#7777FF]]
vim.cmd [[hi JediPoppis gui=NONE guifg=#8888FF guibg=#444488]]
vim.cmd [[hi JediField guifg=#DDDDDD gui=bold,italic,underline]]

s:slide_multi("deco", 3, function(n)
  m.header 'decorations'
  sf {r=3, w=60, text=[[
 - Extra annotations to add informations around buffer text
 - since forever: "debug signs"
 - early hacks: just edit buffer text!
 - vim-jedi: python intel before LSP]]}
   sf {r=8, c=8, w=40, bg="#222222", text=[[
x = np.array([2, 5, 3])
      (axis, kind, order) 
x.sort( 
]], fn=function()
    a.buf_add_highlight(0, 0, "FulMetod", 0, 7, 12)
    a.buf_add_highlight(0, 0, "BriteNumber", 0, 14, 15)
    a.buf_add_highlight(0, 0, "BriteNumber", 0, 17, 18)
    a.buf_add_highlight(0, 0, "BriteNumber", 0, 20, 21)
    a.buf_add_highlight(0, 0, "JediPoppis", 1, 5, 26)
    a.buf_add_highlight(0, 0, "JediField", 1, 7, 11)
    a.buf_add_highlight(0, 0, "FulMetod", 2, 2, 6)
    a.buf_add_highlight(0, 0, "TermCursor", 2, 7, 8)
end}

  sf {r=13, w=60, text=[[
 - Easymotion: change text to display jump markers]], fn=function()
   if n ~= 2 then return end
   a.buf_set_lines(0, 0, -1, true, {[[ - Ehsymotion: chtnge text to displny jump msrkers]]})
   a.buf_add_highlight(0, 0, "MORKER", 0, 4, 5)
   a.buf_add_highlight(0, 0, "MORKER", 0, 17, 18)
   a.buf_add_highlight(0, 0, "MORKER", 0, 35, 36)
   a.buf_add_highlight(0, 0, "MORKER", 0, 44, 45)
 end}

if n>=3 then
  sf {r=14, w=60, text=[[
 - use undo to restore text (fragile!)]]}
end
  sf {r=17, w=60, bg=dred, text=[[
    need a precise way to track inserts on the byte level
    need a way to associate metadata with text]]}

end)


nod_bg = "#2870DD"
nod_hot = "#DD2233"

s:slide_multi("marktree_graf", 3, function(n)
  m.header 'The marktree'

  sf {r=3, w=80, text=[[
Mix and match:
 - klib/kbtree.h: existing c implentation of B-tree
 - Atom markers: optimizing an important atom primitive [1]
 - profit ]],fn = function()
    a.buf_add_highlight(0, 0, "StarLight", 2, 56, -1)
 end}

  local roff = 5
  sf {r=roff+2, c=30, w=20, h=3, bg=nod_bg, text=[[node]]}
  arrow {r=roff+6,c=20, r2=7+roff} sf {r=roff+8, c=9, w=20, h=3, bg=nod_bg, text=[[node]]}
  arrow {r=roff+5,c=42, r2=7+roff} sf {r=roff+8, c=33, w=20, h=3, bg=nod_bg, text=[[node]]}
  arrow {r=roff+6,c=65, r2=7+roff} sf {r=roff+8, c=60, w=20, h=3, bg=nod_bg, text=[[node]]}
  arrow {r=roff+6, c=20, c2=33}
  arrow {r=roff+5, r2=roff+6, c=33}
  arrow {r=roff+6, c=47, c2=64}
  arrow {r=roff+5, r2=roff+6, c=47}

  if n == 2 then
    sf {r=roff+4,c=42,w=1,bg=nod_hot, zindex=55}
    sf {r=roff+10,c=46,w=1,bg=nod_hot, zindex=55}
  elseif n == 3 then
    sf {r=roff+2,h=3,c=42,w=8,bg=nod_hot, zindex=55}
    sf {r=roff+8,h=3,c=46,w=7,bg=nod_hot, zindex=55}
  end

  --arrow {r=roff+4, c=50, c2=64}

  sf{r=17, w=80, text=[[
- editing text: O[log N] marks need to be updated
- insert mark: O[log N]
- delete mark: a big complicated mess but still O[log N]
- lookup mark by mark-id or by position: yes it is O[log N]
- each node stores 10-20 marks -> good cache locality
- up to 19 child nodes per node -> tree remains shallow
  (10000 marks guaranteed to fit in 4 levels)

- WIP: lookup intersecting ranges by position (WIP)

+ marks themselves are compact in memory
- problem: homogenous/humongous Decoration struct

 ]]}

sf{r=31, c=1, bg="#000000", fg="#FF8800", text=[[
[1] blog.atom.io/2015/06/16/optimizing-an-important-atom-primitive.html]]}
end)

s:slide("bufferchange", function()
  m.header 'tracking of buffer changes'
--matchparen: add temporary highlights matchaddpos()
  --does not move with inserted text

 sf {r=5, w=60, text=[[
 - prata om hur detta överlappar extmarks, tree-sitter, LSP

 - 2019: Treesitter! byte-level change tracking
 - 2021: virtual lines
 - 2022-23: inline text (bram patches!)
]]}
end)

s:slide("rtp", function()
  m.header 'runtime path'
  sf {r=3, text=[[
 - before packages (the pathogen/vundle/vim-plug world)
 ]]}

  sf {r=5, bg="#007711", text=[[
call plug#begin('~/.config/nvim/bundle')
plug 'some/example'
call plug#end()]]}

  sf {r=9, h=18, w=80, bg="#0033aa",
  text= -- {{{
  [[
set rtp=/home/bfredl/.config/nvim,/home/bfredl/.config/nvim/start/luarefvim,/etc/xdg/nvim,/home/bfredl/.local/share/nvim/site,/home/bfredl/.config/nvim/bundle/zig.vim,/home/bfredl/.config/nvim/bundle/vimtex,/home/bfredl/.config/nvim/bundle/vim-surround,/home/bfredl/.config/nvim/bundle/vim-sneak,/home/bfredl/.config/nvim/bundle/vim-repeat,/home/bfredl/.config/nvim/bundle/vim-gitgutter,/home/bfredl/.config/nvim/bundle/vim-fugitive,/home/bfredl/.config/nvim/bundle/vim-exchange,/home/bfredl/.config/nvim/bundle/vim-argclinic,/home/bfredl/.config/nvim/bundle/telescope.nvim,/home/bfredl/.config/nvim/bundle/telescope-fzf-native.nvim,/home/bfredl/.config/nvim/bundle/sitruuna.vim,/home/bfredl/.config/nvim/bundle/pres.vim,/home/bfredl/.config/nvim/bundle/popup.nvim,/home/bfredl/.config/nvim/bundle/plenary.nvim,/home/bfredl/.config/nvim/bundle/playground,/home/bfredl/.config/nvim/bundle/nvim-treesitter,/home/bfredl/.config/nvim/bundle/nvim-miniyank,/home/bfredl/.config/nvim/bundle/nvim-luadev,/home/bfredl/.config/nvim/bundle/nvim-lspconfig,/home/bfredl/.config/nvim/bundle/nvim-ipy,/home/bfredl/.config/nvim/bundle/nvim-colorizer.lua,/home/bfredl/.config/nvim/bundle/null-ls.nvim,/home/bfredl/.config/nvim/bundle/leap.nvim,/home/bfredl/.config/nvim/bundle/julia-vim,/home/bfredl/.config/nvim/bundle/ibus-chords,/home/bfredl/.config/nvim/bundle/hop.nvim,/home/bfredl/.config/nvim/bundle/gruvbox,/home/bfredl/.config/nvim/bundle/auto-git-diff,/home/bfredl/.config/nvim/bundle/ack.vim,/home/bfredl/.config/nvim/bundle/a.vim,/home/bfredl/.config/nvim/bundle/LuaSnip,/usr/local/share/nvim/site,/usr/share/nvim/site,/home/bfredl/dev/neovim/runtime,/home/bfredl/dev/neovim/runtime/pack/dist/opt/matchit,/usr/local/lib/nvim,/home/bfredl/.config/nvim/bundle/vimtex/after,/home/bfredl/.config/nvim/bundle/playground/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/home/bfredl/.local/share/nvim/site/after,/etc/xdg/nvim/after,/home/bfredl/.config/nvim/after,/home/bfredl/dev/neovim/build/runtime/
  ]]
--}}}
  }

 sf {r=28, c=2, w=70, text=[[
- problem: parsing string/regex is slow
- solution: calculate an internal search path as an array of strings!
]]}
end)

vim.cmd [[hi StarLight guifg=#ef8008 gui=bold]]
vim.cmd [[hi HasLua guifg=#00FF00 gui=bold]]
s:slide("rtp2", function()
  m.header 'packpath/runtime path'
  sf {r=3, text=[[
 - the Brave New World
 ]]}

  sf {r=5, h=8, w=80, bg="#003388", text=[[
set rtp=/home/bfredl/.config/nvim,/home/bfredl/.config/nvim/start/*,/etc/xdg/nvim,/home/bfredl/.local/share/nvim/site,/home/bfredl/.local/share/nvim/site/pack/*/start/*,/usr/local/share/nvim/site,/usr/share/nvim/site,/usr/local/share/nvim/runtime,/usr/local/share/nvim/runtime/pack/dist/opt/matchit,/usr/local/lib/nvim,/home/bfredl/.local/share/nvim/site/pack/*/start/*/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/home/bfredl/.local/share/nvim/site/after,/etc/xdg/nvim/after,/home/bfredl/.config/nvim/after
  ]], fn=function()
    a.buf_add_highlight(0, 0, "StarLight", 0, 34, 67)
    a.buf_add_highlight(0, 0, "StarLight", 0, 118, 168)
    a.buf_add_highlight(0, 0, "StarLight", 0, 319, 375)
end}

  sf {r=16, w=60, text=[[- faster require'mymod' lookups ]]}
  sf {r=18, w=68, bg="#003388", text=[[
 ~/.config/nvim                                                 lua
 ~/.local/share/nvim/site                                       ---
 ~/.local/share/nvim/site/pack/packer/start/vim-fugitive        ---
 ~/.local/share/nvim/site/pack/packer/start/vim-surround        ---
 ~/.local/share/nvim/site/pack/packer/start/LuaSnip             lua
 ~/.local/share/nvim/site/pack/packer/start/auto-git-diff       ---
 ~/.local/share/nvim/site/pack/packer/start/gitsigns.nvim       lua
 ~/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua  lua
]], fn=function()
    a.buf_add_highlight(0, 0, "HasLua", 0, 64, -1)
    a.buf_add_highlight(0, 0, "HasLua", 4, 64, -1)
    a.buf_add_highlight(0, 0, "HasLua", 6, 64, -1)
    a.buf_add_highlight(0, 0, "HasLua", 7, 64, -1)
end}

  sf {r=25, w=60, text=[[- tangent: precompiled bytecodes ]]}
end)

s:slide("performance", function()
  m.header 'performance '
  sf {r=3, text=[[
 - ?? possible to implement tree-sitter in lua
 - profiling work
 - keysets (remove strcpy/strequal)
 - 80 000 000 xfree calls
 - allocation free msgpack parsing
 - allocation free ui events

 - depessimisation: allocate less, allocate less often
]]}
end)

s:slide("code", function()
  m.header 'code quality / robustness'
  sf {r=3, text=[[
 - enable -Wconversion everywhere (DONE)
 - get rid of char_u, long, etc (WIP)
 - better tooling for linting/styling
]]}
end)

s:slide("futu", function()
  m.header 'future work: text data structure'
  sf {r=4, w=70, text=[[
PROBLEM:

    internal buffer storage "the memline"
  ]], bg=dred}

  sf {r=9, c=10, w=60, text=[[
 char *line = ml_get_buf(buf, linenr, /* modify */ false);
 // all the text on "line" must be represented as a NUL
 // terminated string!
 lenght = strlen(line);]], bg="#FFFFFF", fg="#080808"}

  sf {r=14, w=70, text=[[
This literally DESTROYS all performance for really long lines
a large line must be duplicated for undo
  ]], bg=dred}
  -- arrow {r=14,c=35, r2=18}
  sf {r=20, w=50, text=[[
Future refactor

- use a modern data structure as a rope
- but "char *" line is all over the place
- opt-in per buffer?

  if (buf->is_rope) {
    /* do rope based processing */
  } else {
    /* do memline-based processing */
  }
  ]], bg="#000000"}

end)

s:slide("sum", function()
  m.header 'summary'
  sf {r=3, w=70, text=[[
TBD
  ]]}

sf {r=11, c=0, w=100, h=25, bg="#000000", zindex=30}
sl {r=8, bg="#BB1100", w=20}
sl {r=16, bg="#6622FF", w=72}
sh {r=20, bg="#BB1100", w=65}
sl {r=23, bg="#6622FF", w=85}
--sl {r=20, bg="#DDDDAA", w=65}

  sf {r=10, w=17, center='c', h=3, text=[[
              
    QUESTIONS
              ]], bg='#EEEEBB', fg='#000000'}
end)


s:show (s.slides[s.cur] and s.cur or "titlepage")

vim.cmd [[map <pageDown> <cmd>lua s:mov(1)<cr>]]
vim.cmd [[map <pageUp> <cmd>lua s:mov(-1)<cr>]]

