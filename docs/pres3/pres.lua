local m = dofile'/home/bfredl/config2/nvim/lua/bfredl/moonwatch.lua'
_G.m = m
local a = bfredl.a

local sf = m.float
_G.sf = sf

local s = m.make_show("Ten years of neovim", _G.s)
_G.s = s

m.prepare()
m.cls()

dgreen = "#338844"
dred = "#880000"
dblueish = "#0848C8"

vim.lsp.stop_client(vim.lsp.get_active_clients())
vim.cmd [[set shortmess+=F]]
vim.cmd [[set winblend=0]]
s:slide("titlepage", function()
  vim.cmd [[ hi Normal guibg=#182024]]
  m.header 'Ten years of Neovim'

  -- IMAGEN
end)

s:slide("before", function()
  m.header 'The time before'
end)

s:show (s.slides[s.cur] and s.cur or "titlepage")

vim.cmd [[map <pageDown> <cmd>lua s:mov(1)<cr>]]
vim.cmd [[map <pageUp> <cmd>lua s:mov(-1)<cr>]]

