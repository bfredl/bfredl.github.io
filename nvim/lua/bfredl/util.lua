local h = {}

function h.unprefix(str, pre, to)
  local res = nil
  if vim.startswith(str, pre) then
    local val = string.sub(str, string.len(pre)+1)
    if to then
      return to(val)
    else
      return val
    end
  end
  return nil
end

h.a = {}
h.buf, h.win, h.tabpage = {}, {}, {}
local a, buf, win, tabpage = h.a, h.buf, h.win, h.tabpage

for k,v in pairs(vim.api) do
  a[k] = v
  h.unprefix(k, 'nvim_', function (x)
    a[x] = v
    h.unprefix(x, 'buf_', function (m)
      buf[m] = v
    end)
    h.unprefix(x, 'win_', function (m)
      win[m] = v
    end)
    h.unprefix(x, 'tabpage_', function (m)
      tabpage[m] = v
    end)
    h.unprefix(x, '_buf_', function (m)
      buf['_'..m] = v
    end)
  end)
end

function h.exec(block)
  a.exec(block, false)
end


function h.code(str)
  return a.replace_termcodes(str, true, true, true)
end

function h.namelist()
  local list = {}
  local function byggare(name)
    if name == "END" then
      return list
    end
    return function (value)
      value.name = name
      table.insert(list, value)
      return byggare
    end
  end
  return byggare
end

return h
