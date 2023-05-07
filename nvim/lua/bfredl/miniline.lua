local u = require'bfredl.util'
local colors = require'bfredl.colors'
local c = colors.cdef
local h = {}
local a = u.a

local ns = a.create_namespace 'miniline'

a.set_decoration_provider(ns, {on_win = function()
-- TODO: this should not be needed
a.set_hl_ns_fast(0)
end})
local context = false
local function current()
  -- PGA ORSAKER
  return tonumber(context and vim.g.statusline_winid or vim.g.actual_curwin) == a.get_current_win()
end

-- FUBBIT: we need to load this already, otherwise _LL.LSP hits a race condition
require 'vim.lsp'

local elements = u.namelist()

[[LeftMark]] {
  bg = c.vic4
}

[[ViMode]] {
  func = function()
    if not current() then
      return nil
    end
    local alias = {
      n = 'NORMAL';
      i = 'INSERT';
      niI = 'CTRL-O';
      R = 'REPLAC';
      c= 'C-LINE';
      v= 'VISUAL';
      V= 'V-LINE';
      [''] = 'VBLOCK';
      s = 'SELEKT';
      S = 'S-LINE';
      [''] = 'SBLOCK';
      t = 'TERMNL';
      nt = 'NORM-L';
      ntT = 'C-\\C-O';
    }
    local mode = vim.fn.mode(1)
    return {
      stl = alias[mode] or alias[string.sub(mode,1,1)] or '??????';
      bg = c.vic7;
      fg = c.vic4;
      bold=true;
    }
  end;
}

[[FileName]] {
  stl = '%f%m'; --
  bg = c.vic4;
  fg = c.vic1;
}

[[GitGutter]] {
  expr = function()
    local status, res = pcall(vim.fn.GitGutterGetHunkSummary)
    if not status then return "" end
    local a,m,r = unpack(res)
    if a+m+r == 0 then return "" end
    if true then
      local parts = {}
      if a > 0 then table.insert(parts, "+"..a) end
      if m > 0 then table.insert(parts, ""..m) end
      if r > 0 then table.insert(parts, "-"..r) end
      return ' '..table.concat(parts, " ")
    end
    return (a>0 and'+'..a or'  ') .. ' '
        .. (m>0 and''..m or'  ') .. ' '
        .. (r>0 and'-'..r or'  ')
  end;
  fg = c.vic6a;
  bg = c.vic3;
}


[[Padding]] {
  stl = '%=';
  bg = c.vic3;
}

[[LSP]] {
  expr = function()
    local clients = vim.lsp.buf_get_clients()
    if not clients[1] then
      return ''
    end
    return clients[1].name
  end;
  bg = c.vic6;
  fg = c.vic4;
}


[[FileType]] {
  stl = '%y';
  bg = c.vic6;
  fg = c.vicca;
}

[[Ruler]] {
  stl = '%-14.(%l,%c%V%) %P';
  bg = (__devcolors and c.vic8 or c.vic6b);
  fg = c.vicca;
}
local separator
separator = ''
separator = ''
separator = '▋'
h.expr = {}
_G._LL = h.expr


-- TODO: temas will not require colors to be pre-defined
local lastbg = nil
for i,e in ipairs(elements()) do
  if e.func then
    e = e.func() or {}
  end
  local attr = {bg=e.bg, fg=e.fg, bold=e.bold}
  if next(attr) then
    a.set_hl(ns, e.name, attr)
    e._cdef = "%#"..e.name..'#'
  else
    e._cdef = ""
  end

  if e.expr then
    h.expr[e.name] = e.expr
    e.stl = "%{v:lua._LL."..e.name.."()}"
  end
end


function h.render()
  (a.set_hl_ns_fast or function() end)(ns)
  local pieces = {}
  local lastbg = nil
  context = true -- nonlocal
  local put = function(a) table.insert(pieces, a) end
  for i,e in ipairs(elements()) do
    if e.func then
      local name = e.name
      e = e.func()
      if e then e.name = name end
    end
    local inactive = (e == nil) or (e.active and not e.active())
    if not inactive then
      if lastbg ~= nil then
        if lastbg ~= e.bg then
          a.set_hl(ns, e.name..'Sep', {bg=e.bg, fg=lastbg})
          put ("%#"..e.name..'Sep#'..separator)
        else
          put " "
        end
      end
      lastbg = e.bg

      put (e._cdef)
      if e.stl then
        put (e.stl)
      end
    end
  end
  context = false -- nonlocal
  return table.concat(pieces, '')
end
h.expr._render = h.render

function h.setup()
  (a.set_hl_ns_fast or a._set_hl_ns)(ns)
  u.a.set_option('statusline', '%!v:lua._LL._render()')
end

if package.loaded["bfredl.miniline"] then
  h.setup()
end

return h
