local first_run = not _G.ri

package.loaded.ri = nil -- force reload
_G.ri = require'ri'

if first_run then
  vim.cmd [[autocmd VimEnter * lua _G.ri.on_enter(true)]]
else
  -- already dunnit, so fake it on reload
  _G.ri.on_enter(false)
end
