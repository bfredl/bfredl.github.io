local first_run = not _G.ri
local ri = _G.ri or {}
_G.ri = ri

function ri.on_enter(startup)
  _G.ari = true
end

-- epilogue {{{
if first_run then
  vim.cmd [[autocmd VimEnter * lua _G.ri.on_enter(true)]]
else
  -- already dunnit, so fake it on reload
  ri.on_enter(false)
end

return ri
-- }}}
