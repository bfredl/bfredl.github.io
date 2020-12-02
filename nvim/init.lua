local first_run = not _G.bfredl
package.loaded.bfredl = nil -- force reload
_G.bfredl = require'bfredl'
_G.b = _G.bfredl -- for convenience

if first_run then
  vim.cmd [[autocmd VimEnter * lua _G.bfredl.vimenter(true)]]
else
  -- already dunnit, so fake it on reload
  _G.bfredl.vimenter(false)
end
