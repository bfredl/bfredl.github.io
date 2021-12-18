local h = {}
local u = require'bfredl.util'
local a = u.a
local ns = a.nvim_create_namespace'bfredl.lint'

function h.clint(bufnr)
  local name = a.buf_get_name(bufnr)
  -- 
  local path, fname = u.splitlast(name, 'src/nvim/')
  local makename = 'touches/ran-clint-'..fname:gsub("[/.]","-")
  lines = vim.fn.systemlist("ninja -C "..path.."build/ "..makename)
  for i,l in ipairs(lines) do
    u.unprefix(l, "src/nvim/", function(p)
      lines[i] = p
    end)
  end
  items = vim.fn.getqflist{lines=lines}
  diags = vim.diagnostic.fromqflist(items.items)
  for _,d in pairs(diags) do
    d.col = d.col or 0
  end
  vim.diagnostic.set(ns, 0, diags, {})
end

_G.h = h
return h
