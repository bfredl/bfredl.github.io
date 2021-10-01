local h = {}
local u = require'bfredl.util'
local a = u.a

function h.clint(bufnr)
  name = a.buf_get_name(bufnr)
  -- 
  local path, fname = u.splitlast(name, 'src/nvim/')
  local makename = 'touches/ran-clint-'..fname:gsub("[/.]","-")
  vim.bo[bufnr].makeprg = 'ninja'
  vim.cmd ("make -C "..path.."build/ "..makename)
end

_G.h = h
return h
