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
cfwd = "#CC3333"
cback = "#1199DD"
cbackdark = "#042367"
caccent = "#CCCC33"
cmid = "#6822AA"

a.set_hl(0, "BrightFg", {fg=clight, bold=true})
a.set_hl(0, "BackFg", {fg=cback, bold=true})
a.set_hl(0, "DimFg", {fg="#777777"})
a.set_hl(0, "AccentFg", {fg=caccent, bold=true})

a.set_hl(0, "ZigFg", {fg="#EECC22", bold=true})

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
  local rs, rc = 5, 12
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
- What is Neovim?
- Is neovim the same today as in 2014?
  ]]}
end)

s:slide("whoami", function()
  m.header 'Whoami'
  sf {r=4, w=55, text=[[
- Regular contributor to Neovim since early 2015
- "One of multiple dictators like Bram" for the project
  ]]}

  -- IMAGEN

  sf {r=12, text=[[
- github.com/bfredl                matrix.to/#/@bfredl:matrix.org
  ]], bg="#", fg="#EE8822"}
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
  sf {r=3, text="- use lua for code generation and unit testing"}
  sf {r=4, text="- saner integer types"}
  sf {r=5, text="- the long running char_u series"}
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

s:slide('message', function()
  m.header 'the message.c hydra'

  -- include .dot source as text.
  -- show rendered xdot as a OBS overlay.
end)

s:slide_multi("testing", 2,  function(i)
  m.header 'Regression test-drived development'

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
  sf {r=21, text="+ high quality work produced and merged"} -- emph
  sf {r=22, text="- harder to keep student contributors around afterwards"}
end)

s:slide('language', function()
  m.header 'the language question'

  sf {r=4, w=74, text=[[
original plan: faster vimscript
ZyX'I:s vimscript to lua compiler: ahead of its time

problem: (classic) vimscript is not possible to parse]]}

  sf {r=9, w=30, c=15, bg=cbackdark, text=[[
let x = "a"
let y = "b"
echo x.y

let x = {"y": "foo"}
echo x.y]]}

 sf{r=17, text="async plugins via remote hosts (python, ruby, node)"}
 sf{r=18, text="big lua explosion: vim.api + vim.loop"}
end)

s:slide('language2', function()
  m.header 'the language question II'
  -- this naturally comes AFTER slides where the state of c + c->lua->c

  sf {r=4, text=[[rewrite Neovim in C++/Rust/Zig ??]], fn=function()
    hl("ZigFg", 0, 27, 30)
  end}

  issue(6, "#153", "Is there any plan to use c++?", "Feb 2014")
  issue(8, "#2669", "Switch project to Rust, is that possible at all?", "Jul 2018")

  sf {r=11, text="but how?"}

  -- "rewrite in rust" makes sense with modules
  -- otherwise it just becomes "safe rust", "unsafe rust", "c"
  -- where "unsafe rust" is not a thin interface but the entire code , lol

  sf {r=13, text='"maintain it with zig!" (start with build.zig)'}

  -- just "neovim but rewritten from scratch" is booring, reconsider everything!
  sf {r=14, text='"Don\'t rewrite, reinvent" -> helix'}
  sf {r=15, text="use external tools/libraries written in rust"}
  sf {r=16, text="tree-sitter CLI in rust, tho libtreesitter is still C"}

end)

s:slide('build', function()
  m.header 'Build System!'
end)

s:slide('version', function()
  m.header 'versioning history'
  local ce=30

  sf {r=3,  text='first commit: 2014-01-31'}
  sf {r=5,  text='v0.1.0: 2015-11-01'}
  sf {r=5, c=30, text='async job control, :terminal'}
  sf {r=7,  text='v0.2.0: 2017-05-01'}
  sf {r=7, c=30, text='inccommand'}
  sf {r=9,  text='v0.3.0: 2018-06-11'}
  sf {r=11,  text='v0.4.0: 2019-09-15'}
  sf {r=11, c=30, text='floating windows, virtual text'}
  sf {r=13,  text='v0.5.0: 2021-06-02'}
  sf {r=13, c=30, text='extmarks, LSP, treesitter'}
  sf {r=15,  text='v0.6.0: 2021-11-30'}
  sf {r=17, text='v0.7.0: 2022-04-15'}
  sf {r=19, text='v0.8.0: 2022-09-30'}
  sf {r=21, text='v0.9.0: 2023-04-07'}

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

s:show (s.slides[s.cur] and s.cur or "titlepage")

vim.cmd [[map <pageDown> <cmd>lua s:mov(1)<cr>]]
vim.cmd [[map <pageUp> <cmd>lua s:mov(-1)<cr>]]

