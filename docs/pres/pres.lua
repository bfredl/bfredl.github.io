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

s:slide("neo4", function()
  m.header 'Neovim 0.4'
  sf {r=3, text=[[
- was releaseed on XX (patch 0.4.4 on YY)
- luv event loop (lua code can async io directly)
  - @andreypopp and the luv maintainers
- ext_multigrid (GSOC 2019 @coditiva née @utkarshme)
- nvim_open_win(), 'winblend' (floats, @bfredl :)
bfredl
- MORE]]}

end)

s:slide("multigrid", function()
  m.header 'ext_multigrid/floats'
  sf {r=3, text=[[- These slides are built using floats :)]]}

  sf {c=10, r=5, w=80, h=30, cat="smile2.cat", blend=10, bg="#330033"}
end)

s:slide("multigrid2", function()
  m.header 'ext_multigrid/floats'
  sf {r=3, text=[[- I accidentially a tmux with pseudo-transparent floats
- and I am not even ashamed
- These slides are built using floats]]}

  sf {c=10, r=7, w=9000, h=20, blend=50, bg="#330033"}
end)

s:slide("grids", function()
  m.header 'what is a grid?'
  sf {r=3, text=[[- An ordinary window is a grid
- The pum is a grid
  - The extra info next to the pum is also a grid
- The cmdline is a grid
- Messages is a grid
- Libvterm lives in a grid
  - So we get term apps for free, like fzf
- A nested neovim worker is a grid (containing more grids, babooshka)
  - Decorations (virt text) could be grids? 
- Lsp hover info is a grid.
- Html panes are not grids, but external UI can mix and match
- A big clock is a grid
- Jupyter (IPython repl) is a grid
- Lua output is a grid (and so on and so on)
]]}

  sf {c=vim.o.columns, r=3, w=40, h=30, blend=50, bg="#330033", fn=function()
    keycast(true)
  end}
end)


s:slide("deps", function()
  m.header 'dependency management'
  sf {r=3, text=[[
  - Problem: there not one good standard for dependencies                         .

  - idea: just use luarocks for deps (even .vim code)
  - package versioning and neo/vim version in the same syntem
  - A user dotfiles repo is just another plugin.


  - TJ is Doing The Work (someday soon)
  - Neovim 0.5:]]}
  sf {r=14, c=10, bg="#114477", ft="lua", text=[[
local snippets = vim.require {'norcalli/snippets.nvim', commit="f7f4e43"}
local plenary = vim.require 'nvim-lua/plenary.nvim'
local foobar = vim.require {'someone/foobar', version="0.7+"}

local bfredl = vim.require {'bfredl/bfredl.github.io', subdir='nvim'}
-- ^ Now you can bfredl.moonwatch.show() without my other madness]]}
  sf {r=23, text=[[
  - streach goal: collab with Vim9                                               .]]}

-- notes: you should be able to just use

end)


s:show (s.cur or "intro")
_G.s = s

vim.cmd [[command! -nargs=1 M lua s:show '<args>']]
vim.cmd [[map <pageDown> <cmd>lua s:mov(1)<cr> ]]
vim.cmd [[map <pageUp> <cmd>lua s:mov(-1)<cr> ]]
