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

s:slide("intro", function()
  m.header 'intro'
  sf {r=3, text=[[ The goals of the the Neovim project]]}
end)

s:slide("early", function()
  m.header 'early internal refactors'
  -- TODO: make this a table or something??
  sf {r=3, text=[[
 - platform specific code -> libuv
 - multiple makefiles -> CMake
 - custom tools (proto etc??) -> lua scripts
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
 - c.f. RealWaitForChar just for the lulz?
]]}
end)

s:slide("ui", function()
  m.header 'long running theme: GUI and TUI'
  -- TODO: make this a table or something??
  sf {r=3, text=[[
 - 2014: introduce internal UI interface
   from "gvim as fancy terminal emulator"
   to "TUI is yet another UI"
 - refactor TUI implementation as a separate thread
 - 2016: introduce external widgets: popupmenu, cmdline, wildmenu
 - 2018: linegrid, multigrid (GSOC!), ext_messages
 - 2019: floating windows. external TUI prototype (GSOC)
 - 2022: internal UI "client". vim.ui_attach (showcase noice.nvim !)
 - 2023: Simplify core by reducing "layers" (screen -> grid -> UI > external ui)
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

s:slide("marktree", function()
  m.header 'The marktree'
  sf {r=3, w=50, text=[[
 - kbtree
 - atom markers
 - profit

 - support quick insertion/deletion of marks
 - support quick insertion/deletion of TEXT
 - quick lookup by id
 - quick lookp marks by position
 - quick lookp intersecting ranges by position (WIP)

 - problem: homogenous Decoration struct
]]}
end)

nod_bg = "#338844"

s:slide("marktree_graf", function()
  m.header 'The marktree'
  sf {r=3, c=30, w=20, h=3, bg=nod_bg, text=[[nod]]}
  sf {r=8, c=10, w=20, h=3, bg=nod_bg, text=[[nod]]}
  sf {r=8, c=35, w=20, h=3, bg=nod_bg, text=[[nod]]}
  sf {r=8, c=60, w=20, h=3, bg=nod_bg, text=[[nod]]}
end)

s:slide("rtp", function()
  m.header 'runtime path'
  sf {r=3, w=70, text=[[
 - packpath vs rtp
 - problem: rtp becomes looong
 - problem: parsing string/regex is slow
 - solution: calculate an internal search path as an array of strings
 - show new rtp with globs vs old rtp!
 - faster require'' lookups
 - tangent: precompiled bytecodes
]]}
end)

s:slide("performance", function()
  m.header 'things to talk about'
  sf {r=3, text=[[
 - profiling work
 - 80 000 000 xfree calls
 - keysets (remove strcpy/strequal)
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


s:show (s.cur or "intro")

vim.cmd [[map <pageDown> <cmd>lua s:mov(1)<cr>]]
vim.cmd [[map <pageUp> <cmd>lua s:mov(-1)<cr>]]

