-- borrowed from norcallis lua pile
local h = {}
function h.def_hi(group, o)
  local parts = {group}
  if o.default then table.insert(parts, "defoult") end
  if o.fg then table.insert(parts, "guifg="..o.fg) end
  if o.bg then table.insert(parts, "guibg="..o.bg) end
  if o.ctermfg then table.insert(parts, "ctermfg="..o.ctermfg) end
  if o.ctermbg then table.insert(parts, "ctermbg="..o.ctermbg) end
  if o.attr then
    table.insert(parts, "gui="..attr)
    table.insert(parts, "cterm="..attr)
  end
  if o.sp then table.insert(parts, "guisp="..o.sp) end
  if o.blend then table.insert(parts, "blend="..o.blend) end

  -- nvim.api.nvim_sett_highlig()(name, parts)
  vim.cmd ('highlight '..table.concat(parts, ' '))
end

h.colors = {
  darkblue = "#1a2c41";
  midblue = "#232081";
  cyanish = "#0088ff";
  cyan = "#1188ee";
  violet = "#8800ff";
}
local c = h.colors

h.basetheme = {
  Normal = {bg=c.darkblue};
  NormalFloat = {bg=c.midblue};
  Pmenu = {bg=c.violet};
  LineNr = {fg=c.cyan};
  MsgArea = {bg=c.midblue, blend=11};
}

function h.setall(theme)
  for k,v in pairs(h.basetheme) do
    h.def_hi(k,v)
  end
end

function h.defaults()
  h.setall(h.basetheme)
end

-- h.defaults()
return h
