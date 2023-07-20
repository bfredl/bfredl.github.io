uv = vim.loop
vim.cmd'new'
x = vim.api.nvim_open_term(0, {pty=true})
fd = vim.api.nvim_get_chan_info(x).slave_fd

stdin = uv.new_pipe()

cmd = "less /tmp/asan_nvim_15999.16019"
args = {}

handle, pid = uv.spawn(cmd, {
  args = args,
  stdio = {fd, fd, fd},
  detach = true,
}, vim.schedule_wrap(function()
  print("totenkopf")
end))

if false then
fulpipa = uv.new_pipe()
fulpipa:open(fd)
fulpipa:is_writable()
fulpipa:write'haaaa\n'
end

stdin:write('skrapet\nmer text', function() print 'hoooo' end)
