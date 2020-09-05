--local h = require'bfredl.moonwatch'
local m = dofile'/home/bjorn/config2/nvim/lua/bfredl/moonwatch.lua'
_G.m = m
local a = bfredl.a

local sf = m.float
_G.sf = sf

local s = m.make_show("Neovim 0.5: a vision", _G.s)

m.prepare()
m.cls()

s:slide("intro", function()
  --m.header 'intro'
  sf {r=3, w=80, h=13, cat="sunjon.cat", blend=10}
end)

s:slide("toc", function()
  m.header 'Table of contents'
  sf {r=3, text=[[
- whois @bfredl         .
- Neovim 0.4: what works
  - grids
  - and more grids
- Neovim 0.5: a vision
  - ftplugin 2.0: LSP and tree-sitter
  - dependency management
  - the general X:Y problem
- Final remarks]]}

end)

s:slide("bfredl", function()
  m.header 'whomi'
  sf {r=3, text=[[
- PhD student in deep learning stuff (supposed to be)
- Neovim contributor since 2014
  - plan was to "do" pynvim only
  - but got addicted to C coding
- Fall 2020: 50% Neovim "employee"
  - 0.5 release manager (with justinmk, jamessan)
  - residental madman in charge]]}

end)


s:show (s.cur or "intro")
_G.s = s
