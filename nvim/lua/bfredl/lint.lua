local h = {}
local u = require'bfredl.util'
local a = u.a

function h.clint(bufnr)
  name = a.buf_get_name(bufnr)
  -- 
  local path, fname = u.splitlast(name, 'src/nvim/')
  local makename = 'touches/ran-clint-'..fname:gsub("[/.]","-")
  data = io.popen("ninja -C "..path.."build/ "..makename):read'*a'
end

_G.h = h
return h
