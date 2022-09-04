local h = _G._bfredl_ghostzig or {}
_G._bfredl_ghostzig = h
local u = require'bfredl.util'
local a = u.a
local Job = require'plenary.job'

local ns = a.create_namespace'ghostzig'
h.ghostpath = vim.fn.stdpath'run'..'/ghostzig_'..vim.fn.getpid()

function h.ghostwrite()
  bufname = vim.fn.fnamemodify(vim.fn.bufname(), ':.')
  ghostname = h.ghostpath ..'/'.. bufname
  ghostdir = vim.fn.fnamemodify(ghostname, ':h')
  vim.fn.system({'mkdir', '-p', ghostdir})
  local lines = a.buf_get_lines(0, 0, -1, true)
  local data = table.concat(lines, '\n') .. '\n'
    -- DANSE TILL PIPÅ VÅR TILS DU BLØR
  local ghostpipe = io.open(ghostname, 'wb')
  ghostpipe:write(data)
  ghostpipe:close()
end

function h.ghostbuild(entrypoint)
  h.ghostwrite()
  -- TODO: throttle running jobs
  args = { 'build-exe', '-fno-emit-bin', h.ghostpath..'/'..entrypoint}
  local job = Job:new {
    command = 'zig';
    args = args;
    on_exit = vim.schedule_wrap(function(j, ret)
      local lines = j:stderr_result()
      for i,l in ipairs(lines) do
        -- TODO: translate BACK from the ghost to REALITi
        -- u.unprefix(l, "<stdin>:", function(p)
          --lines[i] = p
        -- end)
      end
      local items = vim.fn.getqflist{lines=lines}
      local diags = vim.diagnostic.fromqflist(items.items)
      vim.diagnostic.set(ns, 0, diags, {})
    end);
    enable_recording = true;
  };
  job:start()
end

function h.ghostzig(entrypoint)
  cwd = vim.fn.getcwd()
  -- TODO: only .zig files?
  vim.fn.system({'cp', '-r', cwd, h.ghostpath})
  a.create_autocmd({'TextChanged', 'TextChangedI'}, {
    pattern = "*.zig";
    callback = function() h.ghostbuild(entrypoint) end;
  })
end
return h
