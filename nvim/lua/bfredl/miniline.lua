local u = require'bfredl.util'
local colors = require'bfredl.colors'
local c = colors.cdef
local h = {}

local function current()
  return tonumber(vim.g.actual_curwin) == vim.api.nvim_get_current_win()
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
}

[[FileName]] {
  stl = '%f%m'; --
  bg = c.vic4;
  fg = c.vic1;
}

[[Padding]] {
  stl = '%='; --
  bg = c.vic3;
}

--separator = '',
--separator = '',
local separator = '▋';
h.expr = {}
_G._LL = h.expr

local pieces = {}
local lastbg = nil
local put = function(a) table.insert(pieces, a) end
for i,e in ipairs(elements()) do
  local cname = "LL_"..e.name
  if lastbg ~= nil then
    colors.def_hi(cname..'Sep', {bg=e.bg, fg=lastbg})
    put ("%#"..cname..'Sep#'..separator)
  end
  lastbg = e.bg

  local attr = {bg=e.bg, fg=e.fg}
  if next(attr) then
    colors.def_hi(cname, attr)
    put ("%#"..cname..'#')
  end
  if e.stl then
    put (e.stl)
  elseif e.expr then
    h.expr[e.name] = e.expr
    put ("%{v:lua._LL."..e.name.."()}")
  end
end
h.stl = table.concat(pieces, '')

function h.setup()
  u.a.set_option('statusline', h.stl)
end

if package.loaded["bfredl.miniline"] then
  h.setup()
end

return h
