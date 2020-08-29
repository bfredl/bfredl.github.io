local first_run = not _G._bfredl
if first_run then
  _G._bfredl = {}
end
local h = _G._bfredl
local a = vim.api

require'packer'.startup(function ()
  use 'norcalli/snippets.nvim'

  use '~/dev/nvim-miniyank'
  use '~/dev/nvim-bufmngr'
  use '~/dev/nvim-luadev'
end)

function h.snippets_setup()
  local s = require'snippets'
  s.use_suggested_mappings()
  s.snippets = {
    _global = {
      todob = "TODO(bfredl):";
      todou = "TODO(upstream):";
      todon = "TODO(neovim):";
      f = "FIXME:";
      re = "return"; -- TODO(bfredl): redundant, integrate snippets with ibus-chords properly
    };
    lua = {
      fun = [[function $1($2)
  $0
end]];
      r = [[require]];
      l = [[local $1 = $0]];
    };
    c = {
      vp = "(void *)";
    };
  }
end


function h.vimenter(startup)
  h.snippets_setup()
  if startup then
    if a.nvim__fork_serve then
      _G.prepfork = true
       a.nvim__fork_serve()
      _G.postfork = true
       -- because reasons
       a.nvim__stupid_test()
    end
  end
end

if first_run then
  vim.cmd [[autocmd VimEnter * lua _G._bfredl.vimenter(true)]]
else
  h.vimenter(false)
end
