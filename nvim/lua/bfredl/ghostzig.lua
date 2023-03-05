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

function h.ghostbuild(entrypoint, test)
  if h.state == "running" or h.state == "throttled" then
    -- require'luadev'.print("THROTTLE")
    h.state = "throttled"
    return
  end
  h.state = "running"
  h.ghostwrite()

  local subcmd = test and 'test' or 'build-exe'
  args = { subcmd, '-fno-emit-bin', h.ghostpath..'/'..entrypoint}
  local start_time = vim.fn.reltime()
  -- require'luadev'.print("START")
  local job = Job:new {
    command = 'zig';
    args = args;
    on_exit = vim.schedule_wrap(function(j, ret)
      local time = vim.fn.reltime(start_time)
      local lines = j:stderr_result()
      for i,l in ipairs(lines) do
         u.unprefix(l, h.ghostpath..'/', function(p)
          lines[i] = p
         end)
      end
      local items = vim.fn.getqflist{lines=lines}
      h.last_clist = items.items
      local diags = vim.diagnostic.fromqflist(items.items)
      _G.lurka = vim.deepcopy(diags)
      bufdiag = {}
      for k,_ in pairs(h.ghosted_bufs) do
        bufdiag[k] = {}
      end
      for _,d in ipairs(diags) do
        bufdiag[d.bufnr] = bufdiag[d.bufnr] or {}
        table.insert(bufdiag[d.bufnr], d)
      end
      for b,d in pairs(bufdiag) do
        h.ghosted_bufs[b] = true
        vim.diagnostic.set(ns, b, d, {})
      end

      if h.state == "throttled" then
        h.state = nil
        h.ghostbuild(entrypoint)
      else
        h.state = "done"
      end
      require'luadev'.print("JOB", h.state, vim.fn.reltimefloat(time))
    end);
    enable_recording = true;
  };
  job:start()
end

local uv = vim.loop

function h.ghostserver(entrypoint, test)
  cwd = vim.fn.getcwd()
  h.ghosted_bufs = {}
  -- TODO: only .zig files?
  vim.fn.system({'cp', '-r', cwd, h.ghostpath})

  local self = {}
  self.stdin = uv.new_pipe(false)
  self.stdout = uv.new_pipe(false)
  self.stderr = uv.new_pipe(false)

  self.stderr:read_start(function(err,data)
    if data then print("åh nej:", data) end
  end)
  self.stdout:read_start(function(err,data)
    print("brus")
  end)

  local subcmd = test and 'test' or 'build-exe'
  args = { subcmd, '-fno-emit-bin', h.ghostpath..'/'..entrypoint, "--listen=-"}
  vim.pretty_print(args)

  self.handle, self.pid = uv.spawn("zig", {
    args = args,
    stdio = {self.stdin, self.stdout, self.stderr}
  }, function()
    print("server exit")
  end)

  return self
end

function h.ghostzig(entrypoint, test)
  cwd = vim.fn.getcwd()
  h.ghosted_bufs = {}
  -- TODO: only .zig files?
  vim.fn.system({'cp', '-r', cwd, h.ghostpath})
  a.create_autocmd({'TextChanged', 'TextChangedI'}, {
    pattern = "*.zig";
    callback = function() h.ghostbuild(entrypoint, test) end;
  })
end
return h
