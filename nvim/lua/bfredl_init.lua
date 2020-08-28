local first_run = not _G._bfredl_vimenter

require'packer'.startup(function ()
  use 'norcalli/snippets.nvim'
end)

function _snippets_setup()
  local s = require'snippets'
  s.use_suggested_mappings()
  s.snippets = {
    _global = {
      todob = "TODO(bfredl) :";
      todou = "TODO(upstream) :";
      todon = "TODO(neovim) :";
    };
    lua = {
      fun = [[function $1($2)
  $0
end]];
    };
  }
end


function _bfredl_vimenter()
  _snippets_setup()
end

if first_run then
  vim.cmd [[autocmd VimEnter * lua _bfredl_vimenter()]]
else
  _bfredl_vimenter()
end

_G._bfredl_loaded = true
