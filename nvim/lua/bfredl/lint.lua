local h = {}
local u = require'bfredl.util'
local a = u.a
local ns = a.nvim_create_namespace'bfredl.lint'
local Job = require'plenary.job'

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

function h.zigcheck()
  if _bfredl_zigscope and _bfredl_zigscope.ghostcmd then
      vim.diagnostic.set(ns, 0, {}, {})
      return
  end
  local lines = a.buf_get_lines(0, 0, -1, true)
  local data = table.concat(lines, '\n') .. '\n'
  local aout = {}
  local args
  args = { 'ast-check' }
  local job = Job:new {
    command = 'zig';
    args = args;
    on_exit = vim.schedule_wrap(function(j, ret)
      local lines = j:stderr_result()
      for i,l in ipairs(lines) do
        u.unprefix(l, "<stdin>:", function(p)
          --lines[i] = p
        end)
      end
      local items = vim.fn.getqflist{lines=lines}
      local diags = vim.diagnostic.fromqflist(items.items)
      vim.diagnostic.set(ns, 0, diags, {})

    end);
    writer = data;
    enable_recording = true;
  };

  job:start()
end

function h.luaload()
  local lines = a.buf_get_lines(0, 0, -1, true)
  local data = table.concat(lines, '\n') .. '\n'
  status, err = loadstring(data, '@<stdin>')
  local diags
  if status then
    diags = {}
  else
      local items = vim.fn.getqflist{lines={err}}
      diags = vim.diagnostic.fromqflist(items.items)
  end
  vim.diagnostic.set(ns, 0, diags, {})
end


function h.zig()
  -- vim.cmd [[autocmd InsertLeave,CursorHold,CursorHoldI,BufWritePre <buffer> lua require'bfredl.lint'.zigcheck()]]
  -- Nooo! you cannot run an external process as a linter on each keypress. Nooo!
  -- haha, astgen go brrr
  -- TODO: disable this when enabling ghostzig
  vim.cmd [[autocmd TextChanged,TextChangedI <buffer> lua require'bfredl.lint'.zigcheck()]]
end

function h.lua()
  -- gör du ens jämn
  vim.cmd [[autocmd TextChanged,TextChangedI <buffer> lua require'bfredl.lint'.luaload()]]
end

_G.h = h
return h
