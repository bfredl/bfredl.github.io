_G._bfredl_loaded = true

require'packer'.startup(function ()
    use 'norcalli/snippets.nvim'
end)

function _snippets_setup()
  local s = require'snippets'
  s.use_suggested_mappings()
  s.snippets = {
    _global = {
      todob = "TODO(bfredl) :";
    }
  }
end
