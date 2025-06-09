local h = _G._bfredl_zigscope or {}
_G._bfredl_zigscope = h
local u = require'bfredl.util'
local a = u.a
local Job = require'plenary.job'
_G.h = h

local ns = a.create_namespace'zigscope'
h.ghostpath = vim.fn.stdpath'run'..'/zigscope'..vim.fn.getpid()
h.ghostcmd = nil
h.ghostargs = {}

h.ghosted_bufs = {} -- bufs which might have stale diags

a.create_autocmd({'TextChanged', 'TextChangedI'}, {
  pattern = "*.zig";
  callback = function() h.ghostbuild() end;
})

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

function h.ghostbuild()
  if h.ghostcmd == nil then return end -- disabled
  if h.state == "running" or h.state == "throttled" then
    -- require'luadev'.print("THROTTLE")
    h.state = "throttled"
    return
  end
  h.state = "running"
  h.ghostwrite()

  local start_time = vim.fn.reltime()
  -- require'luadev'.print("START")
  local job = Job:new {
    command = h.ghostcmd;
    args = h.ghostargs;
    on_exit = vim.schedule_wrap(function(j, ret)
      local time = vim.fn.reltime(start_time)
      local lines = j:stderr_result()
      _G.zig_lines = lines
      for i,l in ipairs(lines) do
         u.unprefix(l, h.ghostpath..'/', function(p)
          lines[i] = p
         end)
      end
      local items = vim.fn.getqflist{lines=lines}
      h.last_clist = items
      local diags = vim.diagnostic.fromqflist(items.items)
      h.last_diags = diags
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
        h.ghostbuild(command, args)
      else
        h.state = "done"
      end
      require'luadev'.print("JOB", h.state, vim.fn.reltimefloat(time))
    end);
    enable_recording = true;
  };
  job:start()
end

function h.speedjump()
  if h.last_clist then
      vim.fn.setqflist({}, ' ', h.last_clist)
      vim.cmd 'cfirst'
  end
end


function h.precopy()
  cwd = vim.fn.getcwd()
  -- TODO: only .zig files?
  vim.fn.system({'mkdir', '-p', h.ghostpath})
  vim.fn.system({'cp', '-r', cwd .. '/src', h.ghostpath .. '/src'})
end

function h.ghostzig(entrypoint, test)
  h.precopy()

  local command = 'zig'
  local subcmd = test and 'test' or 'build-exe'
  args = { subcmd, '-lc', '-fno-emit-bin', h.ghostpath..'/'..entrypoint}
end

h.smol_cmdline ='/home/bfredl/local/zig14/bin/zig build-exe -ODebug -Mroot=/home/bfredl/dev/forklift/src/run_ir.zig --cache-dir /home/bfredl/dev/forklift/.zig-cache --global-cache-dir /home/bfredl/.cache/zig --name run --zig-lib-dir /home/bfredl/local/zig14/lib/zig/ --listen=-'
h.test_big_cmdline = '/home/bfredl/local/zig14/bin/zig build-exe -ODebug --dep wasm_shelf --dep clap -Mroot=/home/bfredl/dev/wasm_anon/src/main.zig --dep forklift -Mwasm_shelf=/home/bfredl/dev/wasm_anon/src/wasm_shelf.zig -Mclap=/home/bfredl/.cache/zig/p/clap-0.10.0-oBajB434AQBDh-Ei3YtoKIRxZacVPF1iSwp3IX_ZB8f0/clap.zig -Mforklift=/home/bfredl/.cache/zig/p/forklift-0.0.0-Dkn_kZxgAwDeIOlll7z_in-S5r4a31QkMMDu5G006Ba2/src/forklift.zig --cache-dir /home/bfredl/dev/wasm_anon/.zig-cache --global-cache-dir /home/bfredl/.cache/zig --name wasm_run --zig-lib-dir /home/bfredl/local/zig14/lib/zig/ --listen=-'
-- NOTE: this uses the in-dev copy of forklift, but its files aren't being ghosted. E.g. they need to be saved to take effect. Not sure if we want to handle this
-- or one repo root should just GLOM both packages
h.test_big_cmdline2 = '/home/bfredl/local/zig14/bin/zig build-exe -ODebug --dep wasm_shelf --dep clap -Mroot=/home/bfredl/dev/wasm_anon/src/main.zig --dep forklift -Mwasm_shelf=/home/bfredl/dev/wasm_anon/src/wasm_shelf.zig -Mclap=/home/bfredl/.cache/zig/p/clap-0.10.0-oBajB434AQBDh-Ei3YtoKIRxZacVPF1iSwp3IX_ZB8f0/clap.zig -Mforklift=/home/bfredl/dev/forklift/src/forklift.zig --cache-dir /home/bfredl/dev/wasm_anon/.zig-cache --global-cache-dir /home/bfredl/.cache/zig --name wasm_run --zig-lib-dir /home/bfredl/local/zig14/lib/zig/ --listen=-'
h.secondary_cmdline = '/home/bfredl/local/zig14/bin/zig build-exe -fllvm -ODebug --dep vaxis --dep xev -Mroot=/home/bfredl/dev/zignvim/src/tui_main.zig -ODebug --dep code_point --dep grapheme --dep DisplayWidth --dep zigimg -Mvaxis=/home/bfredl/.cache/zig/p/vaxis-0.1.0-BWNV_JEMCQBskZQsnlzh6GoyHSDgOi41bCoZIB2pW-E7/src/main.zig -Mxev=/home/bfredl/.cache/zig/p/libxev-0.0.0-86vtc-zkEgB7uv1i0Sa6ytJETZQi_lHJrImu9mLb9moi/src/main.zig -ODebug -Mcode_point=/home/bfredl/.cache/zig/p/zg-0.13.4-AAAAAGiZ7QLz4pvECFa_wG4O4TP4FLABHHbemH2KakWM/src/code_point.zig -ODebug --dep code_point --dep GraphemeData -Mgrapheme=/home/bfredl/.cache/zig/p/zg-0.13.4-AAAAAGiZ7QLz4pvECFa_wG4O4TP4FLABHHbemH2KakWM/src/grapheme.zig -ODebug --dep ascii --dep code_point --dep grapheme --dep DisplayWidthData -MDisplayWidth=/home/bfredl/.cache/zig/p/zg-0.13.4-AAAAAGiZ7QLz4pvECFa_wG4O4TP4FLABHHbemH2KakWM/src/DisplayWidth.zig -Mzigimg=/home/bfredl/.cache/zig/p/zigimg-0.1.0-lly-O6N2EABOxke8dqyzCwhtUCAafqP35zC7wsZ4Ddxj/zigimg.zig -ODebug --dep gbp -MGraphemeData=/home/bfredl/.cache/zig/p/zg-0.13.4-AAAAAGiZ7QLz4pvECFa_wG4O4TP4FLABHHbemH2KakWM/src/GraphemeData.zig -ODebug -Mascii=/home/bfredl/.cache/zig/p/zg-0.13.4-AAAAAGiZ7QLz4pvECFa_wG4O4TP4FLABHHbemH2KakWM/src/ascii.zig -ODebug --dep dwp --dep GraphemeData -MDisplayWidthData=/home/bfredl/.cache/zig/p/zg-0.13.4-AAAAAGiZ7QLz4pvECFa_wG4O4TP4FLABHHbemH2KakWM/src/WidthData.zig -Mgbp=/home/bfredl/dev/zignvim/.zig-cache/o/0f82e83670e15c49d1cbc2d29ff2574f/gbp.bin.z -Mdwp=/home/bfredl/dev/zignvim/.zig-cache/o/d129ffa595744a8b2d70918ba3303cc2/dwp.bin.z --cache-dir /home/bfredl/dev/zignvim/.zig-cache --global-cache-dir /home/bfredl/.cache/zig --name zignvim_tui --zig-lib-dir /home/bfredl/local/zig14/lib/zig/ --listen=-'

function h.zigscope()
  local paths = {
    ['/home/bfredl/dev/wasm_anon']=h.test_big_cmdline2,
    ['/home/bfredl/dev/forklift']=h.smol_cmdline,
    ['/home/bfredl/dev/zignvim']=h.secondary_cmdline,
  }

  local cwd = vim.uv.cwd()
  for k,v in pairs(paths) do
    if vim.startswith(cwd, k) then
      h.ghostzig_mod(v)
      vim.keymap.set('n', '-', h.speedjump)
      return
    end
  end
  vim.api.nvim_echo({{"que?"}}, true, {})
end


function h.ghostzig_mod(big_cmdline)
  h.precopy()

  if type(big_cmdline) == 'string' then
    big_cmdline = vim.split(big_cmdline, ' ')
  end
  local fixed_cmdline = vim.deepcopy(big_cmdline)

  local badly = nil
  local modules = {}
  for i = 1,#big_cmdline do
    local val = big_cmdline[i]
    if vim.startswith(val, "-M") then
      print(val)
      local rest = string.sub(val, 3)
      local point = string.find(rest, "=")
      local mod = string.sub(rest, 1, point-1)
      local path = string.sub(rest, point+1)
      local location = 1+#path-string.find(string.reverse(path), "/")
      local dirpath = string.sub(path, 1, location)
      local filnamn = string.sub(path, location+1)
      modules[mod] = {i, dirpath, filnamn}
      print(mod, dirpath, filnamn)
    end
    -- server would be nice but we are not there yet
    if val == "--listen=-" then
      badly = i
    end
  end
  if badly then
    table.remove(fixed_cmdline, badly)
  end

  -- maybe "root" doesn't matter? just check for paths below $CWD ??
  roten = modules.root
  if roten == nil then error('we assume a -Mroot module here') end
  root_path = roten[2]
  if not vim.endswith(root_path, "/src/") then error('fixa') end

  for mod, data in pairs(modules) do
    if data[2] == root_path then
      fixed_cmdline[data[1]] = "-M"..mod.."="..h.ghostpath.."/src/"..data[3]
      print("BEGHAAA", mod)
    end
  end

  h.ghostcmd = table.remove(fixed_cmdline,1)
  table.insert(fixed_cmdline, "-fno-emit-bin")
  h.ghostargs = fixed_cmdline
end

return h
