local h = {}

-- def_hi {{{
-- borrowed from norcallis lua pile
function h.def_hi(group, o)
  local parts = {group}
  if o.default then table.insert(parts, "defoult") end
  if o.fg then table.insert(parts, "guifg="..o.fg) end
  if o.bg then table.insert(parts, "guibg="..o.bg) end
  if o.ctermfg then table.insert(parts, "ctermfg="..o.ctermfg) end
  if o.ctermbg then table.insert(parts, "ctermbg="..o.ctermbg) end
  if o.attr then
    table.insert(parts, "gui="..o.attr)
    table.insert(parts, "cterm="..o.attr)
  end
  if o.sp then table.insert(parts, "guisp="..o.sp) end
  if o.blend then table.insert(parts, "blend="..o.blend) end

  -- nvim.api.nvim_sett_highlig()(name, parts)
  vim.cmd ('highlight '..table.concat(parts, ' '))
end
-- }}}

h.colors = {
  darkblue = "#1a3c54";
  midblue = "#232081";
  ultragray = "#909090";
  cyanish = "#0088ff";
  cyan = "#4188ee";
  violet = "#8800ff";

  vic0 = "#000000";
  vic1 = "#ffffff";
  vic2 = "#a8734a";
  vic3 = "#e9b287";
  vic4 = "#772d26";
  vic5 = "#b66862";
  vic6 = "#85d4dc";
  vic7 = "#c5ffff";
  vic8 = "#a85fb4";
  vic9 = "#e99df5";
  vica = "#559e4a";
  vicb = "#92df87";
  vicc = "#42348b";
  vicd = "#7e70ca";
  vice = "#bdcc71";
  vicf = "#ffffb0";
  vicca= "#322a68";
}
local c = h.colors

h.basetheme = {
  -- TODO: luahl hook to interatively preview these already
  Normal = {bg=c.vicc};
  NormalFloat = {bg=c.midblue};
  Pmenu = {bg=c.violet};
  LineNr = {fg=c.vicf, bg=c.vicd};
  MsgArea = {bg=c.midblue, blend=11};
  Folded = {bg=c.ultragray, fg="#222222", attr="bold"};
  NonText = {fg=c.vic5};
  String = {fg=c.vic1, bg=c.vicca};
}

function h.setall(theme) -- {{{
  for k,v in pairs(h.basetheme) do
    h.def_hi(k,v)
  end
end -- }}}

function h.defaults()
  h.setall(h.basetheme)
end

function h.fastmode() -- {{{
  local b = _G.bfredl
  local bb = b.a.get_current_buf()
  function _G._ccheck()
    local f = b.buf.get_lines(bb, 0, -1, true)

    local text = table.concat(f, "\n")
    local codes = loadstring(text, b.buf.get_name(bb))
    if codes then
      codes().defaults()
    end
  end

  b.exec [[
  augroup fastmode
    au InsertLeave,TextChanged <buffer> lua _G._ccheck()
  augroup END
  ]]
end -- }}}

h.defaults()
--h.fastmode()

return h
