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

function arrow(args)
  local r2,c2 = args.r2 or args.r, args.c2 or args.c
  sf {r=args.r, c=args.c, bg="#aaaaaa", h = r2-args.r+1, w=1}
end

s:slide("titlepage", function()
  m.header 'Neovim internals: past and future'
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
- Neovim is often compared w vim and other on features
- Let's talk about the internal refactors which enables
  - maintenance of exiting code
  - add more features
  ]]}

end)

s:slide("early", function()
  m.header 'early internal refactors'
  -- TODO: make this a table or something??
  sf {r=3, text=[[First wave of refactors: maintainability]]}
  sf {r=5, w=50, text=[[
 - remove most #ifdef FEAT_XXXX
 - platform specific code -> libuv
 - multiple makefiles -> CMake
 - custom tools, macros -> lua scripts
 - multiple "script hosts" -> unifdied API
]]}
end)

s:slide("event", function()
  m.header 'event handling'
  sf {r=8, h=5, text=[[
    internal refactor: replace internal event handling with livuv

uv_loop_xx()

  ]], bg=dgreen}
  arrow {r=14,c=35, r2=18}
  sf {r=20, c=20, h=5, text=[[
    event/os interface for lua plugins

vim.loop.pipe()
vim.loop.spawn("subprocess")
...
  ]], bg=dred}
  sf {r=3, text=[[
 - from libuv internally to get vim.loop _plugin_ interface "for free"
[TODO: c.f. RealWaitForChar in vim as well ?]
]]}
end)

s:slide("ui", function()
  m.header 'long running theme: GUI and TUI'
  -- TODO: make this a table or something??
  sf {r=3, c=2, w=68, text=[[
 - 2014: introduce internal UI interface
   from "gvim as fancy terminal emulator"
   to "TUI is yet another UI"
 - refactor TUI implementation as a separate thread
 - 2016: introduce external widgets: popupmenu, cmdline, wildmenu
 - 2018: linegrid, multigrid (GSOC!), ext_messages
 - 2019: floating windows. external TUI prototype (GSOC)
 - 2022: internal UI "client". vim.ui_attach (showcase noice.nvim !)
 - 2023(?): Simplify core by reducing "layers"
            (screen -> grid -> UI > external ui)
]]}
end)

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

s:slide("intredraw_line", function()
  m.header 'redrawing: internals'
  -- LURING? show the vim 7.4 version with #ifdefs first?
  sf {r=3, text=[[ win_line() code
  ]]}
end)
s:slide("evo", function()
  m.header 'Evolution of the UI protocol'
end)

protobg = "#280055"

s:slide("evo1", function()
  m.header 'Evolution of the UI protocol: initial version'
  sf {r=3, text=[[ui_attach(20,50,rgb=true) =>]]}
  sf {r=5, c=15, w=50, bg=protobg, text=[[
resize(20,50)
update_bg(0x112222)
clear()
cursor_goto(0,0)
put[('h'), ('e'), ('l'), ('l'), ('o')]
cursor_goto(1,0)
highlight_set({foreground=0x0000FF, bold=true})
put('~')
cursor_goto(2,0)
put('~')
...]]}
end)

s:slide("evo2", function()
  m.header 'Evolution of the UI protocol: "linegrid"'
  sf {r=3, text=[[nvim_ui_attach(20,50,{rgb=true, ext_linegrid=true}) =>]]}
  sf {r=5, c=15, w=50, bg=protobg, text=[[
grid_resize(1,20,50)
grid_clear(1)
FYLL I
...]]}
end)

s:slide("evo3", function()
  m.header 'Evolution of the UI protocol: "multigrid"'
  sf {r=3, text=[[nvim_ui_attach(20,50,{rgb=true, ext_multigrid=true}) =>]]}
  sf {r=5, c=15, w=50, bg=protobg, text=[[
FYLL I
...]]}
end)

s:slide("evo4", function()
  m.header 'Evolution of the UI protocol: widgets'
  sf {r=3, text=[[nvim_ui_attach(20,50,{..., ext_popupmenu=true, ext_cmdline=true}) =>]]}
  sf {r=5, c=15, w=50, bg=protobg, text=[[
FYLL I
...]]}
end)

s:slide("evo5", function()
  m.header 'Evolution of the UI protocol: widgets in TUI'
  sf {r=3, h=8, w=50, text=[[SCREENSHOT OF NOICE.NIVM]], bg=dgreen}

  sf {r=15, text=[[
this approaches a lua reimplementation of the TUI based on multigrid
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
box (7,c0) [[win_update()]]
line (8,c0)
box (9,c0) [[win_line():]]
line (10,c0)
box (11,c0) [[grid_line() ??]]
line (12,c0)
box (13,c0) [[ui_line() ??]]
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
end)

s:slide("deco", function()
  m.header 'decorations'
  sf {r=3, w=60, text=[[
 - 2015: per buffer highlights ("bufhl")
   (primitive, only updates to lines!)

 - 2016: internal discussion of "extmarks" start (timeyyy)
 - 2018: redefine highlight groups per window (winhl)
 - 20??: first sketch of virtual text (EOL only)
 - 2019: Treesitter! byte-level change tracking
 - 2020: the marktree (breakout)
 - 2021: virtual lines
 - 2022-23: inline text (bram patches!)
]]}
end)

s:slide("decostate", function()
  m.header 'state of the art: 2000'
  sf {r=3, w=60, text=[[
-- easymotion/vim-jedi: edit buffer text to show inline text
  messing with undo state, icky!
--matchparen: add temporary highlights matchaddpos()
  does not move with inserted text
  ]]}

  sf {r=10, w=60, bg=dred, text=[[
    need a precise way to track inserts on the byte level
    need a way to associate metadata with text]]}

end)

s:slide("marktree", function()
  m.header 'The marktree'
  sf {r=3, w=60, text=[[
 - kbtree
 - atom markers
 - profit

 - support quick insertion/deletion of marks
 - support quick insertion/deletion of TEXT
 - quick lookup by id
 - quick lookup marks by position
 - quick lookup intersecting ranges by position (WIP)
]]}
end)

nod_bg = "#338844"

s:slide("marktree_graf", function()
  m.header 'The marktree'
  sf {r=3, c=30, w=20, h=3, bg=nod_bg, text=[[nod]]}
  arrow {r=6,c=20, r2=7} sf {r=8, c=10, w=20, h=3, bg=nod_bg, text=[[nod]]}
  arrow {r=6,c=40, r2=7} sf {r=8, c=35, w=20, h=3, bg=nod_bg, text=[[nod]]}
  arrow {r=6,c=65, r2=7} sf {r=8, c=60, w=20, h=3, bg=nod_bg, text=[[nod]]}

  sf{r=20, w=50, text=[[
 + items themselves are compact in memory
 - problem: homogenous/humongous Decoration struct
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

  sf {r=9, h=13, w=60, bg="#0033aa",
  text= -- {{{
  [[
set rtp=/home/bfredl/.config/nvim,/home/bfredl/.config/nvim/start/luarefvim,/etc/xdg/nvim,/home/bfredl/.local/share/nvim/site,/home/bfredl/.config/nvim/bundle/zig.vim,/home/bfredl/.config/nvim/bundle/vimtex,/home/bfredl/.config/nvim/bundle/vim-surround,/home/bfredl/.config/nvim/bundle/vim-sneak,/home/bfredl/.config/nvim/bundle/vim-repeat,/home/bfredl/.config/nvim/bundle/vim-gitgutter,/home/bfredl/.config/nvim/bundle/vim-fugitive,/home/bfredl/.config/nvim/bundle/vim-exchange,/home/bfredl/.config/nvim/bundle/vim-argclinic,/home/bfredl/.config/nvim/bundle/telescope.nvim,/home/bfredl/.config/nvim/bundle/telescope-fzf-native.nvim,/home/bfredl/.config/nvim/bundle/sitruuna.vim,/home/bfredl/.config/nvim/bundle/pres.vim,/home/bfredl/.config/nvim/bundle/popup.nvim,/home/bfredl/.config/nvim/bundle/plenary.nvim,/home/bfredl/.config/nvim/bundle/playground,/home/bfredl/.config/nvim/bundle/nvim-treesitter,/home/bfredl/.config/nvim/bundle/nvim-miniyank,/home/bfredl/.config/nvim/bundle/nvim-luadev,/home/bfredl/.config/nvim/bundle/nvim-lspconfig,/home/bfredl/.config/nvim/bundle/nvim-ipy,/home/bfredl/.config/nvim/bundle/nvim-colorizer.lua,/home/bfredl/.config/nvim/bundle/null-ls.nvim,/home/bfredl/.config/nvim/bundle/leap.nvim,/home/bfredl/.config/nvim/bundle/julia-vim,/home/bfredl/.config/nvim/bundle/ibus-chords,/home/bfredl/.config/nvim/bundle/hop.nvim,/home/bfredl/.config/nvim/bundle/gruvbox,/home/bfredl/.config/nvim/bundle/auto-git-diff,/home/bfredl/.config/nvim/bundle/ack.vim,/home/bfredl/.config/nvim/bundle/a.vim,/home/bfredl/.config/nvim/bundle/LuaSnip,/usr/local/share/nvim/site,/usr/share/nvim/site,/home/bfredl/dev/neovim/runtime,/home/bfredl/dev/neovim/runtime/pack/dist/opt/matchit,/usr/local/lib/nvim,/home/bfredl/.config/nvim/bundle/vimtex/after,/home/bfredl/.config/nvim/bundle/playground/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/home/bfredl/.local/share/nvim/site/after,/etc/xdg/nvim/after,/home/bfredl/.config/nvim/after,/home/bfredl/dev/neovim/build/runtime/
  ]]
--}}}
  }

 sf {r=24, w=70, text=[[
 - problem: parsing string/regex is slow
 - solution: calculate an internal search path
             as an array of strings
]]}
end)

vim.cmd [[hi StarLight guifg=#ef8008 gui=bold]]
vim.cmd [[hi HasLua guifg=#00FF00 gui=bold]]
s:slide("rtp2", function()
  m.header 'packpath/runtime path'
  sf {r=3, text=[[
 - the Brave New World
 ]]}

  sf {r=6, h=10, w=60, bg="#003388", text=[[
set rtp=/home/bfredl/.config/nvim,/home/bfredl/.config/nvim/start/*,/etc/xdg/nvim,/home/bfredl/.local/share/nvim/site,/home/bfredl/.local/share/nvim/site/pack/*/start/*,/usr/local/share/nvim/site,/usr/share/nvim/site,/usr/local/share/nvim/runtime,/usr/local/share/nvim/runtime/pack/dist/opt/matchit,/usr/local/lib/nvim,/home/bfredl/.local/share/nvim/site/pack/*/start/*/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/home/bfredl/.local/share/nvim/site/after,/etc/xdg/nvim/after,/home/bfredl/.config/nvim/after
  ]], fn=function()
    a.buf_add_highlight(0, 0, "StarLight", 0, 34, 67)
    a.buf_add_highlight(0, 0, "StarLight", 0, 118, 168)
    a.buf_add_highlight(0, 0, "StarLight", 0, 319, 375)
end}

  sf {r=17, w=60, text=[[- faster require'' lookups ]]}
  sf {r=19, w=68, bg="#003388", text=[[
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

  sf {r=10, w=17, center='c', h=3, text=[[
              
    QUESTIONS
              ]], bg=dgreen}
end)


s:show (s.cur or "titlepage")

vim.cmd [[map <pageDown> <cmd>lua s:mov(1)<cr>]]
vim.cmd [[map <pageUp> <cmd>lua s:mov(-1)<cr>]]

