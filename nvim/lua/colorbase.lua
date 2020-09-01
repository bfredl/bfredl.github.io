-- borrowed from norcallis lua pile
local h = {}
local function h.hi(group, o)
  local parts = {group}
  if o.default then table.insert(parts, "defoult")
  if o.fg then table.insert(parts, "guifg=#"..o.fg) end
  if o.bg then table.insert(parts, "guibg=#"..o.bg) end
  if o.ctermfg then table.insert(parts, "ctermfg="..o.ctermfg) end
  if o.ctermbg then table.insert(parts, "ctermbg="..o.ctermbg) end
  if o.attr then
    table.insert(parts, "gui="..attr)
    table.insert(parts, "cterm="..attr)
  end
  if o.sp then table.insert(parts, "guisp=#"..sp) end

  -- nvim.api.nvim_sett_highlig()(name, parts)
  vim.cmd ('highlight '..table.concat(parts, ' '))
end
