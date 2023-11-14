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
cback = "#1199EE"
caccent = "#CCCC33"
cmid = "#6611BB"

vim.lsp.stop_client(vim.lsp.get_active_clients())
vim.cmd [[set shortmess+=F]]
vim.cmd [[set winblend=0]]
s:slide('titlepage', function()
  vim.cmd [[ hi Normal guibg=#080808]]
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

s:slide('before', function()
  m.header 'The time before'

  -- neovim: how and why

  sf {r=4, w=74, text=[[
  event handling before:
    CursorHold
    --remote protocol]]}
end)

s:slide('language', function()
  m.header 'the language question'

  sf {r=4, w=74, text=[[
    original plan: faster vimscript
    ZyX'I:s vimscript to lua compiler: ahead of its time

    problem: (classic) vimscript is not possible to parse

    let x = "a"
    let y = "b"
    echo x.y
    let x = {"y": "foo"}
    echo x.y
  ]]}
end)

s:slide('release', function()
  m.header 'releases and versioning'
end)

s:show (s.slides[s.cur] and s.cur or "titlepage")

vim.cmd [[map <pageDown> <cmd>lua s:mov(1)<cr>]]
vim.cmd [[map <pageUp> <cmd>lua s:mov(-1)<cr>]]

