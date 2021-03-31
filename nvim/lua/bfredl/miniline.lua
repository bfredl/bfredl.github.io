local u = require'bfredl.util'
local colors = require'bfredl.colors'
local c = colors.cdef
local h = {}

local context = false
local function current()
  -- PGA ORSAKER
  return tonumber(context and vim.g.statusline_winid or vim.g.actual_curwin) == vim.api.nvim_get_current_win()
end

local elements = u.namelist()

[[LeftMark]] {
  bg = c.vic4
}

[[ViMode]] {
  expr = function()
    if not current() then return vim.fn.winnr() end
    local alias = {n = 'NORMAL',i = 'INSERT',c= 'C-LINE',v= 'VISUAL', V= 'VISUAL', [''] = 'VISUAL'}
    return alias[vim.fn.mode()]
  end;
  bg = c.vic7;
  fg = c.vic4;
  attr={bold=true};
  active = function() return current() end;
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
  bg = c.vic6b;
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
  local cname = "LL_"..e.name
  if lastbg ~= nil then
    if lastbg ~= e.bg then
      colors.def_hi(cname..'Sep', {bg=e.bg, fg=lastbg})
    end
  end
  lastbg = e.bg

  local attr = {bg=e.bg, fg=e.fg}
  if next(attr) then
    colors.def_hi(cname, attr)
    e._cdef = "%#"..cname..'#'
  else
    e._cdef = ""
  end

  if e.expr then
    h.expr[e.name] = e.expr
    e.stl = "%{v:lua._LL."..e.name.."()}"
  end
end


function h.render()
  local pieces = {}
  local lastbg = nil
  context = true -- nonlocal
  local put = function(a) table.insert(pieces, a) end
  for i,e in ipairs(elements()) do
    local inactive = e.active and not e.active()
    if not inactive then
      local cname = "LL_"..e.name
      if lastbg ~= nil then
        if lastbg ~= e.bg then
          put ("%#"..cname..'Sep#'..separator)
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
  u.a.set_option('statusline', '%!v:lua._LL._render()')
end

if package.loaded["bfredl.miniline"] then
  h.setup()
end

return h
