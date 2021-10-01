local first_run = not _G.bfredl

if first_run then
  local status, fire = pcall(require, 'vim.dumpster_fire')
  if status then
    fire.dumpster_test("/tmp/mycache")
  end
end

package.loaded.bfredl = nil -- force reload
_G.bfredl = require'bfredl'
_G.b = _G.bfredl -- for convenience


if first_run then
  vim.cmd [[autocmd VimEnter * lua _G.bfredl.vimenter(true)]]
else
  -- already dunnit, so fake it on reload
  _G.bfredl.vimenter(false)
end
