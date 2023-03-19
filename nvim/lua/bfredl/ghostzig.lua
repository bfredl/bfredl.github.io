local h = _G._bfredl_ghostzig or {}
_G._bfredl_ghostzig = h
local u = require'bfredl.util'
local a = u.a
local Job = require'plenary.job'
_G.h = h

local ns = a.create_namespace'ghostzig'
h.ghostpath = vim.fn.stdpath'run'..'/ghostzig_'..vim.fn.getpid()

function h.ghostwrite()
  bufname = vim.fn.fnamemodify(vim.fn.bufname(), ':.')
  ghostname = h.ghostpath ..'/'.. bufname
  ghostdir = vim.fn.fnamemodify(ghostname, ':h')
  vim.fn.system({'mkdir', '-p', ghostdir})
  local lines = a.buf_get_lines(0, 0, -1, true)
  local data = table.concat(lines, '\n') .. '\n'
    -- DANSE TILL PIPÃ… VÃ…R TILS DU BLÃ˜R
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
  self.stdout_hnd = uv.pipe()
  self.stdout = uv.new_pipe()
  self.stdout:open(self.stdout_hnd.read)
  self.stderr_hnd = uv.pipe()
  self.stderr = uv.new_pipe()
  self.stderr:open(self.stderr_hnd.read)

  self.out_chunks = {}

  self.stderr:read_start(function(err,data)
    if data then print(data) end
  end)
  self.stdout:read_start(function(err,data)
    if data then
      print("brus")
      table.insert(self.out_chunks, data)
    end
  end)

  local subcmd = test and 'test' or 'build-exe'
  args = {
    subcmd;
    -- '-fno-emit-bin';
    h.ghostpath..'/'..entrypoint;
    "--listen=-";
  }
  vim.print(args)

  self.handle, self.pid = uv.spawn("zig", {
    args = args,
    stdio = {self.stdin, self.stdout_hnd.write, self.stderr_hnd.write}
  }, function()
    print("server exit")
  end)

  return self
end

fuldata = "\0\0\0\0\25\0\0\0000.11.0-dev.1911+4f077b98a\1\0\0\0\175\1\0\0%\0\0\0\19\1\0\0\1\0\0\0$\0\0\0\n\0\0\0h\2\0\0\31\0\0\0\21Z\0\0\25Z\0\0\30Z\0\0\0\0\0\0\0\0\0\0[\0\0\0&\2\0\0!\0\0\0\134P\0\0\134P\0\0\142P\0\0\0\0\0\0\0\0\0\0\147\0\0\0!\0\0\0\23\0\0\0k\3\0\0q\3\0\0w\3\0\0\191\0\0\0\3\0\0\0\1\0\0\0\2\0\0\0B\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\222\0\0\0\1\0\0\0\18\0\0\0\0\0\0\0 \0\0\0\0callMain\0/home/bfredl/dev/zig/build/stage3/lib/zig/std/start.zig\0initEventLoopAndCallMain\0/home/bfredl/dev/zig/build/stage3/lib/zig/std/start.zig\0/run/user/1000/ghostzig_8403/src/run_ir.zig\0    const argv = std.os.argve;\0root struct of file 'os' has no member named 'argve'\0"
-- data = fuldata
--

local ffi = require'ffi'
function u32(bytes, where)
  return ffi.cast('uint32_t*', bytes)[where or 0]
end

function parse_output(data)
  if #data < 8 then
    eof()
  end
  kinda = u32(string.sub(data, 1, 4))
  lenny = u32(string.sub(data, 5, 8))
  if #data < 8+lenny then
    eof()
  end
  print(kinda, lenny)

  body = string.sub(data,9, 8+lenny) -- there's a body alright

  if kinda == 1 then -- errors
    parse_errors(body)
  end

  nxt = string.sub(data,9+lenny)
  data = nxt
end

function parse_errors(body)
    extra_len = u32(body)
    string_bytes_len = u32(body,1)
    extra_data = string.sub(body,9,8+extra_len*4)
    string_data = string.sub(body,8+extra_len*4+1)
    extra = ffi.cast('uint32_t*', extra_data)
    string_bytes = ffi.cast('char*', string_data)

    eml_len = extra[0]
    eml_start = extra[1]
    eml_log_text = extra[2]

    first_at = extra[eml_start]

    msg_idx = extra[first_at]
    msg_count = extra[first_at+1]
    msg_src_loc = extra[first_at+2]
    msg_notes_len = extra[first_at+3]
    msg = ffi.string(string_bytes+msg_idx)

    src_at = msg_src_loc

    function src_loc(src_at)
      local src_path = extra[src_at]
      local source_line = extra[src_at+6]
      local reference_trace_len = extra[src_at+7]
      local srcref_at = src_at+8
      local ref_trace = {}
      local ref_hidden = nil
      for i = 1,reference_trace_len do
        ref_decl_name = extra[srcref_at+2*(i-1)+0]
        ref_src_loc = extra[srcref_at+2*(i-1)+1]
        if ref_src_loc ~= 0 then
          ref_decl = ffi.string(string_bytes+ref_decl_name)
          table.insert(ref_trace, {decl_name=ffi.string(string_bytes+ref_decl_name), src_loc=ref_src_loc})
        else
          ref_hidden = ref_decl_name
        end
      end
      return {
        line = extra[src_at+1];
        col = extra[src_at+2];
        span_start = extra[src_at+3];
        span_main = extra[src_at+4];
        span_end = extra[src_at+5];
        src_path = ffi.string(string_bytes+src_path);
        source_line = ffi.string(string_bytes+source_line);
        ref_trace = ref_trace;
        ref_hidden = ref_hidden;
      }
    end

    loc = src_loc(src_at)
    vim.print(loc)
    for _,t in ipairs(loc.ref_trace) do
      vim.print(src_loc(t.src_loc))
    end

    i = 1
    string.sub(string_bytes, src_path_idx+1) -- todo: first \0
end

neodata = "\0\0\0\0\25\0\0\0000.11.0-dev.2158+c31007bb4\2\0\0\0\25\0\0\0Semantic Analysis [1892] \1\0\0\0\205\1\0\0&\0\0\0-\1\0\0\1\0\0\0%\0\0\0\0\0\0\0\18\0\0\0\27\0\0\0\26\0\0\0>\3\0\0E\3\0\0L\3\0\0\0\0\0\0\0\0\0\0_\0\0\0\\\0\0\0\20\0\0\0\213\t\0\0\219\t\0\0\225\t\0\0\0\0\0\0\0\0\0\0\151\0\0\0\201\0\0\0\17\0\0\0J\31\0\0J\31\0\0}\31\0\0\205\0\0\0\3\0\0\0\1\0\0\0\3\0\0\0N\0\0\0\v\0\0\0\0\0\0\0\0\0\0\0\19\1\0\0\1\0\0\0\19\0\0\0\0\0\0\0!\0\0\0\0print__anon_8817\0/home/bfredl/dev/zig/build/stage3/lib/zig/std/io/writer.zig\0print__anon_6687\0/home/bfredl/dev/zig/build/stage3/lib/zig/std/debug.zig\0/home/bfredl/dev/zig/build/stage3/lib/zig/std/fmt.zig\0            1 => @compileError(\"unused argument in '\" ++ fmt ++ \"'\"),\0unused argument in 'no.\n'\0"


--[[
data = neodata
  ffi = require'ffi'
s = h.ghostserver("src/run_ir.zig", false)
adata = table.concat(s.out_chunks)
adata == fuldata
adata == neodata
xdata = vim.inspect(adata)
for i = 129,255 do
  xdata = string.gsub(xdata, string.char(i), "\\"..tostring(i))
end
print(xdata)
print(vim.inspect(adata):gsub("Í", "\\205"):gsub("Õ", "\\213"))


s.stdin:write('\1\0\0\0')
s.stdin:write('\0\0\0\0')
s.out_chunks

--]]

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
