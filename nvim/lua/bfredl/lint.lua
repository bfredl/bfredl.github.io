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

function h.astcheck(bufnr)
  local name = a.buf_get_name(bufnr)
  local lines = a.buf_get_lines(bufnr, 0, -1, true)
  local data = table.concat(lines, '\n') .. '\n'
  local aout = {}
  local job = Job:new {
    command = 'zig';
    args = { 'ast-check' };
    on_exit = vim.schedule_wrap(function(j, ret)
      local lines = j:stderr_result()
      for i,l in ipairs(lines) do
        u.unprefix(l, "<stdin>:", function(p)
          --lines[i] = p
        end)
      end
      items = vim.fn.getqflist{lines=lines}
      diags = vim.diagnostic.fromqflist(items.items)
      print(vim.inspect(items))
      vim.diagnostic.set(ns, 0, diags, {})

    end);
    writer = data;
    enable_recording = true;
  };

  job:start()
end

function h.zig()
  -- vim.cmd [[autocmd InsertLeave,CursorHold,CursorHoldI,BufWritePre <buffer> lua require'bfredl.lint'.astcheck()]]
  -- Nooo! you cannot run an external process as a linter on each keypress. Nooo!
  -- haha, astgen go brrr
  vim.cmd [[autocmd TextChanged,TextChangedI <buffer> lua require'bfredl.lint'.astcheck()]]
end

_G.h = h
return h
