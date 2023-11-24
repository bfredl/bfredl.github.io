local m = dofile'/home/bfredl/config2/nvim/lua/bfredl/moonwatch.lua'
_G.m = m
local a = bfredl.a

local sf = m.float
_G.sf = sf

local s = m.make_show("Ten years of neovim", _G.s)
_G.s = s

m.prepare()
m.cls()

clight = "#FFFFFF"
cmiddim = "#aaaaaa"
cfwd = "#CC3333"
cback = "#1199DD"
cbackdark = "#042367"
caccent = "#E8BB22"
cmid = "#6822AA"

a.set_hl(0, "BrightFg", {fg=clight, bold=true})
a.set_hl(0, "FwdFg", {fg=cfwd, bold=true})
a.set_hl(0, "BackFg", {fg=cback, bold=true})
a.set_hl(0, "DimFg", {fg="#777777"})
a.set_hl(0, "AccentFg", {fg=caccent, bold=true})

ns = a.create_namespace'pres'

function hl(nam, l, c, c2)
  a.buf_add_highlight(0, ns, nam, l, c, c2)
end

function issue(r, num, name, date)
  date = date and (" ("..date..")") or ""
  sf {r=r, c=8, text=num..": "..name..date, fn=function()
    hl("BrightFg", 0, 0, #num+1)
    hl("DimFg", 0, #num+2+#name, -1)
  end}
end

  vim.cmd [[ hi Normal guibg=#080808 guifg=#e0e0e0]]

vim.lsp.stop_client(vim.lsp.get_active_clients())
vim.cmd [[set shortmess+=F]]
vim.cmd [[set winblend=0]]
s:slide('titlepage', function()
  local rs, rc = 5, 18
  sf {r=rs+1, c=rc, text='NEOVIM', fg=clight}
  local bgs = {cfwd, caccent, cback, cmid}
  for i = 1,4 do
    local s = 12
    sf {r=rs+3,h=5,c=rc+s*(i-1),w=s-2,bg=bgs[i]}
  end
  sf {r=rs+9, c=rc+33, text='10 YEARS GONE', fg=clight}

  -- IMAGEN
end)

s:slide("intro", function()
  m.header 'Overview'
  sf {r=3, w=70, c=3, text=[[
- Neovim was announced early 2014, nearly 10 years ago
- How has our goals and overal design desicions evolved?
- A lot of things has happened in 10 years
  ]]}
end)

s:slide("whoami", function()
  m.header 'Whoami'
  sf {r=4, w=55, text=[[
- Regular contributor to Neovim since early 2015
  ]]}

  -- IMAGEN

  sf {r=12, text=[[
- github.com/bfredl                matrix.to/#/@bfredl:matrix.org
  ]], bg="#", fg=caccent}
end)

s:slide('before', function()
  m.header 'The time before'

  -- neovim: how and why

  sf {r=3, w=74, text=[[
  event handling before:
    CursorHold
    --remote protocol]]}

    sf {r=7, text="by floobits, for real-time collaboration:"}
    issue(8, "vim-dev", "[PATCH] Asynchronous functions (settimeout, setinterval, ...)", "sep 2013")

    sf {r=10, text="by tarruda:"}
    issue(11, "vim-dev", "[PATCH] Proof of concept: thread-safe message queue", "dec 2013")
    issue(12, "vim-dev", "[PATCH] Non-blocking job control for vimscript", "jan 2014")

  sf {r=14, w=76, bg=cbackdark, text=[[
> It is my second attempt to bring multitasking to vim, but unlike the
> event-loop/message queue patch, this one does not rely on multithreading,
> using only system functions available on most unixes. If required, it
> could also be ported to windows(I think it has a concept called IOCP
> which provides a replacement to the 'select' system call). ]]}
end)

s:slide('fundraiser', function()
  m.header 'The original announcement: fundraiser'

  sf {r=3, c=4, h=25, w=85, text=[[

$10,000 will allow me to dedicate two months of full time work to this project, which will be enough to implement the following:

- New, modern multi-platform UI written using qtlua.
- New curses UI written using luaposix. [...] remove a great deal of code dedicated to handling terminals in the core source.
- New testing UI written in Lua with migration of all tests to this interface. [...] Write vim tests using lua's bdd framework busted which will improve readability and run speed.
- New plugin architecture, with a python compatibility layer for using vim plugins written in python.
- Full port of the editor IO to libuv.
- Cross-platform implementation of job control for vimscript (easy on top of libuv).
- Distributions for Windows, Linux and Mac, and a Windows installer.

Streatch goals:

- Reimplement vimscript as a language that compiles to lua. In other words, vimscript will be to lua what coffeescript is to javascript.

- Refactor the editor into a library. It will require changing the way vim reads input or emits output.  This will allow programs to embed the editor in the same process for better efficiency (no more marshalling of json/msgpack documents between the GUI and the core).

]]}

  sf {r=30, w=80, h=2, text="http://web.archive.org/web/20140530212019/https://www.bountysource.com/fundraisers/539-neovim-vim-s-rebirth-for-the-21st-century"}
  sf {r=32, text="inspect source and delete 'display: none;' style :P"}
end)

s:slide('refactor', function()
  m.header 'early refactors'
  sf {r=4, text="Most important change: no more #ifdef FEAT_XXX"}
  sf {r=6, c=8, w=50, text=[[

 #ifdef FEAT_SYN_HL
 	if (!(wlv->cul_screenline
 # ifdef FEAT_DIFF
 		    && wlv->diff_hlf == (hlf_T)0
 # endif
 	     ))
 	    wlv->saved_char_attr = wlv->char_attr;
 	else
 #endif
 	    wlv->saved_char_attr = 0;
]], bg=cbackdark, fg="#cccccc", fn=function()
  vim.cmd "match BackFg /\\v#\\s?\\a+/"
  vim.cmd "2match BackFG /\\vFEAT_[A-Z_]+/"
end}

 sf {r=19, bg="BrightFg", text="This is a prerequisite for many other refactors!"}

end)

s:slide('refactor2', function()
  m.header 'important refactors'

  sf {r=3, text="- get rid of conditional compilation"}
  sf {r=4, text="- use lua for code generation and unit testing"}
  sf {r=5, text="- saner integer types"}
  sf {r=6, text="- the long running char_u series"}
end)


s:slide('multibytes', function()
  m.header 'case study: multibyte and screen text'

  issue(4, "72cf89b", "Process files through unifdef to remove tons of FEAT_* macros", "jan 2014")

  issue(6, "#2929", "Don't allow changing encoding after startup scripts", "sep 2015")
  issue(7, "#3655", "Always use encoding=utf-8 per default", "Jan 2016")
  issue(8, "#2095", "Only allow encoding=utf-8", "nov 2016")

  issue(10, "#7992", "Represent Screen state as UTF-8", "jun 2018")
  issue(11, "#25214", "change schar_T representation to be more compact", "sep 2023")

  issue(13, "#25503", "refactor(grid): do arabic shaping in one place", "okt 2023")
  issue(14, "#25905", "refactor(grid): reimplement 'rightleft' as a post-processing step", "nov 2023")

  sf {r=16, text="related: ui protocol changes. see last years talk!"}

  issue(18, "#8221", "UI grid protocol revision: line based updates", "jul 2018")

  -- RANT MODE: overemphasize how important the first step has been for the rest!
  -- whenever I think to the self "should I backport this cleanup to vim/vim"
  -- get hit by that wall of #ifdef:s in the way
end)

s:slide('options', function()
  m.header 'case study: options.lua'

  issue(3, "#2288 (part)", "options: Move option definitions to options.lua", "jul 2015")
  issue(4, "#15078", 'refactor: remove obsolete distinction of "vi" vs "vim" defaults', "jul 2021")
  issue(6, "#24528", "docs(options): take ownership of options.txt ", "aug 2023")

  sf {r=10, text="TODO: actually show some codes"}
end)

s:slide('message', function()
  m.header 'the message.c hydra'

  sf {r=3, w=70, h=37, text=[[
digraph {
  redrawcmdline[color=blue,fontcolor=blue];
  put_on_cmdline -> redrawcmdline -> msg_outtrans_len_attr
  msg_outtrans_len_attr -> msg_puts_attr_len
  msg_putchar[shape=plaintext];
  msg_putchar -> msg_putchar_attr -> msg_puts_attr
  msg_puts_attr[shape=plaintext];
  msg_puts_attr -> msg_puts_attr_len
  msg_puts_attr_len -> msg_puts_display -> t_puts -> grid_puts
  msg_puts_display -> screen_puts_mbyte -> msg_screen_putchar
  msg_puts_display -> msg_screen_putchar -> grid_putchar
  screen_puts_mbyte -> grid_puts; grid_puts[color=red,fontcolor=red];
  grid_putchar[color=red,fontcolor=red];
  msg_attr_keep -> msg_multiline_attr -> msg_outtrans_len_attr
  msg_multiline_attr -> msg_putchar_attr
  msg_attr -> msg_attr_keep -> msg_outtrans_attr
  msg_outtrans_attr[shape=plaintext]
  msg_outtrans_len[shape=plaintext]
  msg_outtrans[shape=plaintext]
  msg_outtrans -> msg_outtrans_attr -> msg_outtrans_len_attr
  msg_outtrans_len -> msg_outtrans_len_attr
  msg -> msg_attr_keep; msg[shape=plaintext]
  msg_attr[shape=plaintext]
  emsg -> emsg_multiline -> msg_attr_keep; emsg[shape=plaintext]
  put_on_cmdline -> cursorcmd -> cmd_cursor_goto
  cursorcmd[color=blue,fontcolor=blue]
  cmd_cursor_goto[color=blue,fontcolor=blue,shape=plaintext]
  cmd_cursor_goto -> ui_grid_cursor_goto
  ui_grid_cursor_goto[color=red,fontcolor=red];
  put_on_cmdline[color=blue,fontcolor=blue]
  do_more_prompt -> disp_sb_line -> msg_puts_display
  msg_puts_display -> do_more_prompt
}
  ]]}

  -- include .dot source as text.
  -- show rendered xdot as a OBS overlay.
end)

s:slide_multi("testing", 2,  function(i)
  m.header 'Regression test-driven development'

  sf {r=4, text="RPC-protocol driven testing"}
  sf {r=5, text="screen tests"}

local  texten = [===[
it('buffer highlighting', function()
  screen = Screen.new(40, 8)
  screen:attach()
  insert([[
    these are some lines
    with colorful text]])

  meths.buf_add_highlight(0, -1, "String", 0 , 10, 14)
  meths.buf_add_highlight(0, -1, "Statement", 1 , 5, -1)

  screen:snapshot_util()
end)]===]

  if i == 2 then
    texten = [===[
it('buffer highlighting', function()
  screen = Screen.new(40, 8)
  screen:attach()
  insert([[
    these are some lines
    with colorful text]])

  meths.buf_add_highlight(0, -1, "String", 0 , 10, 14)
  meths.buf_add_highlight(0, -1, "Statement", 1 , 5, -1)

  screen:expect{grid=[[
    these are {1:some} lines                    |
    with {2:colorful tex^t}                      |
    {3:~                                       }|
    {3:~                                       }|
    {3:~                                       }|
                                            |
  ]], attr_ids={
    [1] = {foreground = Screen.colors.Magenta1};
    [2] = {bold = true, foreground = Screen.colors.Brown};
    [3] = {bold = true, foreground = Screen.colors.Blue1};
  }}
end)]===]
  end

  sf {r=7, w=60, bg=cmid, text=texten}

  if i == 2 then
    sf {r=31, text=[[over 4000 expected screen states]]}
  end
end)

s:slide('student', function()
  m.header 'student collaborations'

  sf {r=3, text="incremental substitution"}
  sf {r=4, text="a group of students from X university"}

  issue(6, "#4794", ':substitute "live" feedback', "May 2016, tracking issue")
  issue(7, "#4811", 'Incsub 1', "May 2016, draft")

  -- issue(9, "#4915", 'Incsub 2', "Jun 2016")
  -- issue(10, "#5226", 'Incsub 3', "Nov 2016")
  -- issue(11, "#5661", 'Incsub 4', "Nov 2016, merged")
  issue(9, "#4915+#5226+#5661", 'Incsub 2-4', "Nov 2016, merged")

  sf {r=11, text="Google summer of code: 2018-2020"}

  issue(13, "#8455", 'Break up screen grid into resizable window grids', "Aug 2018")
  issue(14, "#8337", 'GSoC Project Outline for a .NET API Client', "Aug 2018")
  issue(15, "#9943", 'Multiprocessing feature', "Aug 2019")
  issue(16, "#10071", 'TUI (Terminal UI) remote attachment', "Aug 2019")
  issue(17, "#12531+12593", "TUI + fswatch 'autoread'", "Aug 2020")
  
  sf {r=20, text="+ good processes for onboarding new contributions"}
  sf {r=21, text="+ high quality work produced and merged", fg=caccent}
  sf {r=22, text="- harder to keep student contributors around afterwards"}
end)

s:slide('language', function()
  m.header 'the language question'

  sf {r=4, w=74, text=[[
original plan: faster vimscript
ZyX-I's vimscript to lua compiler: ahead of its time

problem: (classic) vimscript is not possible to parse]]}

  sf {r=9, w=25, c=15, bg=cfwd, text=[[
 let x = "a"
 let y = "b"
 echo x.y

 let x = {"y": "foo"}
 echo x.y]]}

 sf{r=17, text="async plugins via remote hosts (python, ruby, node)"}
 sf{r=18, text="big lua explosion: vim.api + vim.loop"}

 sf{r=20, text="vim9script to lua transpiler"}
end)

s:slide('luaaaaaa', function()
  m.header 'tema: lua'

  issue(3, "d04ca90", "Add basic infrastructure for unit testing", "feb 2014")
  sf {r=4,  c=10, text="luajit + luarocks + moonscript"}

  issue(5, "#1128", "Drop moonscript", "aug 2014")
  issue(6, "#509", "Add msgpack_rpc_dispatch/metadata generator", "apr 2014")

  issue(7, "#4411", "lua interpreter in core", "may 2017")
  issue(8, "#10175", "lua: introduce vim.loop (expose libuv event-loop)", "june 2019")
  issue(9, "#12235", "startup: support init.lua as user config", "dec 2020")
  issue(10, "#14686", "Allow lua to be used in runtime files", "jun 2021")

  issue(11, "#14661", "feat(lua): add api and lua autocmds", "feb 2022")
  issue(12, "#16591", "feat(lua): add support for lua keymaps", "jan 2022")

  issue(15, "#24523", "feat(lua-types): types for vim.api.*", "-- 2023")

  sf {r=20, text="conclusion: shift from 'infrastructure' language to primary plugin/config lang", fg=cback}
  -- go through all the usage of lua internally and externally
end)

s:slide('language2', function()
  m.header 'the language question II'
  -- this naturally comes AFTER slides where the state of c + c->lua->c

  sf {r=4, text=[[rewrite Neovim in C++/Rust/Zig ??]], fn=function()
    hl("AccentFg", 0, 27, 30)
  end}

  issue(6, "#153", "Is there any plan to use c++?", "Feb 2014")
  issue(8, "#2669", "Switch project to Rust, is that possible at all?", "Jul 2018")

  sf {r=11, text="but how?"}

  -- "rewrite in rust" makes sense with modules
  -- otherwise it just becomes "safe rust", "unsafe rust", "c"
  -- where "unsafe rust" is not a thin interface but the entire code , lol
  sf {r=12, text='TODO: the "safe rust", "unsafe rust", "c" infographic'}

  sf {r=13, text='"maintain it with zig!" (start with build.zig)'}

  -- just "neovim but rewritten from scratch" is booring, reconsider everything!
  sf {r=14, text='"Don\'t rewrite, reinvent" -> helix'}
  sf {r=15, text="use external tools/libraries written in rust"}
  sf {r=16, text="tree-sitter CLI in rust, tho libtreesitter is still C"}
end)

s:slide('ctool', function()
  m.header 'Tooling for C'

  sf {r=3, text="Given the consistent strategy to stick with C for a long while" }
  sf {r=4, text='"Just write good C code and not bad C code"'}
  sf {r=5, text='invest in good tooling for maintaining and writing C code'}

  sf {r=8, text='Sanitizers (address, undefined behavior, leaks)'}
  sf {r=9, text="Multithreading: just don't do it"}
  sf {r=10, text="Static analyzers:"}
  sf {r=11, c=12, text="PVS"}
  sf {r=12, c=12, text="coverity"}
  sf {r=13, c=12, text="clang-analyzer/clang-tidy"}

  sf {r=15, text="linting formatting:"}
  sf {r=16, c=12, text="clint.py"}
  sf {r=17, c=12, text="uncrustify"}

end)

s:slide('build', function()
  m.header 'Build System!'
end)

s:slide('dependencies', function()
  m.header 'Dependencies used by neovim'

  sf {r=3, text="bundled:"}
  sf {r=5, c=8, text="libuv"}
  sf {r=6, c=8, text="unibilium (terminfo without curses)"}
  sf {r=7, c=8, text="libtermkey"}
  sf {r=8, c=8, text="libvterm"}
  sf {r=9, c=8, text="luajit (or lua 5.1)"}
  sf {r=10, c=8, text="libluv"}
  sf {r=11, c=8, text="libtreesitter"}

  sf {r=14, text="vendored:"}
  sf {r=16, c=8, text="klib (klist, khash, etc)"}
  sf {r=17, c=8, text="lpeg (lua expression grammars)"}
  sf {r=18, c=8, text="xdiff"}

  -- Don't NIH the wheel
  -- Bundle vs vendor
end)


s:slide('version', function()
  m.header 'versioning history'
  local ce=28

  sf {r=3,  text='first commit: 2014-01-31', fg=cmiddim}
  sf {r=5,  text='v0.1.0: 2015-11-01', fg=cmiddim}
  sf {r=5, c=ce, text='async job control, :terminal'}
  sf {r=7,  text='v0.2.0: 2017-05-01', fg=cmiddim}
  sf {r=7, c=ce, text='inccommand'}
  sf {r=9,  text='v0.3.0: 2018-06-11', fg=cmiddim}
  sf {r=9, c=ce, text="buffer updates, <cmd> key"}
  sf {r=11,  text='v0.4.0: 2019-09-15', fg=cmiddim}
  sf {r=11, c=ce, text='floating windows, virtual text'}
  sf {r=13,  text='v0.5.0: 2021-06-02', fg=cmiddim}
  sf {r=13, c=ce, text='extmarks, LSP, tree-sitter, init.lua'}
  sf {r=15,  text='v0.6.0: 2021-11-30', fg=cmiddim}
  sf {r=15, c=ce, text="diagnostic API, better 'packpath'"}
  sf {r=17, text='v0.7.0: 2022-04-15', fg=cmiddim}
  sf {r=17, c=ce, text="lua core interfaces"}
  sf {r=19, text='v0.8.0: 2022-09-30', fg=cmiddim}
  sf {r=19, c=ce, text="aaaa"}
  sf {r=21, text='v0.9.0: 2023-04-07', fg=cmiddim}
  sf {r=21, c=ce, text=":inspect, vim.secure"}

  sf {r=15, c=66, w=1, h=7, bg=cmid}
  sf {r=17, c=69, w=20, text = "tree-sitter,\nLSP maturation"}
end)

s:slide('release', function()
  m.header 'releases and versioning'

  sf {r=5, text="starting with v0.4.0, separatate release-0.x branches"}
  sf {r=7, text="release notes:"}
  sf {r=8, c=8, text="<=0.4.0: big bash script listing all commits"}
  sf {r=9, c=8, text="0.5.0 and later: conventional commits + git-cliff"}

  sf {r=11, c=8, w=65,  bg=cmid, text=[[
feat(clipboard): add OSC 52 clipboard support
refactor(sign): move legacy signs to extmarks
fix(job-control): make jobwait() flush UI after hiding cursor]]}
end)

s:slide('delet', function()
  m.header 'deleted features/modules'

    issue(4, "--", "in-tree GUI (gtk, qt, mswin)", "feb 2014")
    issue(5, "1622", "vi 'compatible' mode", "feb 2014")
    sf {r=6, text="languages other than vimscript, if_lua"}

    issue(9, "18547", "remove 'insertmode'", "may 2022")
    issue(10, "20545", "remove :cscope", "okt 2022")
    issue(11, "21472", "remove :hardcopy", "dec 2022")

  sf {r=13, text="remove 'bundles' of changed behavior which can be configured manually (:behave)"}

  sf {r=15, text='not ported features:'}
  sf {r=17, c=15, text='defaults.vim (a third set of defaults)'}
end)

s:slide('conclude', function()
  m.header 'after 10 years: did we stick to the original goals'

  sf {r=3, text='then: transpile vimscript into lua', fg=cfwd}
  sf {r=4, text='then: async plugins as co-processes in any language', fg=cfwd}
  sf {r=5, text='now: lua as first class plugin and config', fg=cback}
  sf {r=6, text='now: keep compat with vim8 script', fg=cback}
  sf {r=7, text='now: async plugins by lua bindings andr wrappers around libuv',fg=cback}
  sf {r=8, text='there and back again: transpile runtime vim9 code into lua',fg=cback}

  sf {r=10, text='goal: RPC protocol for GUI:s and embedders'}
  sf {r=11, text='TUI as a separate process written in ~~lua~~ C.', fn=function()
    hl("FwdFg", 0, 37, 44)
    hl("BackFg", 0, 45, 46)
  end}
  sf {r=12, text="GUI:s as third-party projects", fg=cback}

  -- answer: sorta. We solved the same problems but often in a different way
end)

s:show (s.slides[s.cur] and s.cur or "titlepage")

vim.cmd [[map <pageDown> <cmd>lua s:mov(1)<cr>]]
vim.cmd [[map <pageUp> <cmd>lua s:mov(-1)<cr>]]

