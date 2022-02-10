local uv = vim.loop
local Path = require'plenary.path'
local Job = require'plenary.job'

local function _make_tmpfile(template, cb)
  uv.fs_mkstemp(template,function(err,fd,path)
    assert(not err, err)
    uv.fs_close(fd, function(err)
      assert(not err, err)
      cb(path)
    end)
  end)
end

_make_tmpfile('gui-widgets.tmpXXXXXX', function(path)
  print(path)
end)
