--local h = require'bfredl.moonwatch'
local m = dofile'/home/bjorn/config2/nvim/lua/bfredl/moonwatch.lua'
_G.m = m
local a = bfredl.a

local sf = m.float
_G.sf = sf

local s = m.make_show("Neovim 0.5: a vision")

m.prepare()
m.cls()

s:slide("intro", function()
  --m.header 'intro'
  sf {r=3, w=80, h=25, cat="sunjon.cat", blend=20}
end)
s:slide("toc", function()
  m.header 'Table of contents'
  sf {r=3, text="- whois @bfredl"}
  sf {r=4, text="- Neovim 0.4: what works"}
  sf {r=5, text="- Neovim 0.5: a vision"}
  sf {r=6, text="- Final remarks"}
end)

s:show "intro"
