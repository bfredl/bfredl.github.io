--local h = require'bfredl.moonwatch'
local m = dofile'/home/bjorn/config2/nvim/lua/bfredl/moonwatch.lua'
_G.m = m
local a = bfredl.a

local sf = m.float
_G.sf = sf

m.prepare()
m.cls()
sf {r=3, text="graj", blend=50}
sf {r=5, text="möö", blend=30, bg="#33FF00"}
