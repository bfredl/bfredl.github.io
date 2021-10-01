local h = _G._bfredl_util or {}
_G._bfredl_util = h
_G.u = _G._bfredl_util

h.counter = h.counter or 0
function h.id()
  h.counter = h.counter + 1
  return h.counter
end

function h.splitlast(str, sep, plain)
  local vals = vim.split(str, sep)
  local last = vals[#vals]
  vals[#vals] = nil
  local prefix = table.concat(vals, sep)
  return prefix, last
end

function h.unprefix(str, pre, to)
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

function h.code(str)
  return a.replace_termcodes(str, true, true, true)
end

function h.namelist()
  local list = {}
  local function byggare(name)
    if name == nil then
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


h.options = a.get_all_options_info()
for n,v in pairs(a.get_all_options_info()) do
  if v.shortname ~= "" then h.options[v.shortname] = h.options[n] end
end
h.set = (function()
  local function meta(name)
    local boolval = true
    h.unprefix(name, 'no', function(nam)
      if h.options[nam] and h.options[nam].type == 'boolean' then
        name = nam
        boolval = false
      end
    end)
    local o = h.options[name]
    if not o then
      error(name)
    end

    local function unmeta(val)
      -- all options except window options have global value,
      -- because reasons.
      if o.global_local or o.scope ~= "win" then
        a.set_option(name, val)
      end

      if o.scope == "win" then
        win.set_option(0, name, val)
      elseif o.scope == "buf" then
        buf.set_option(0, name, val)
      end
      return meta
    end
    return o.type == "boolean" and unmeta(boolval) or unmeta
  end
  return meta
end)()

function h.mapcmd(lhs) return function(cmd)
  a.set_keymap('', lhs, '<cmd>'..string.gsub(cmd,'<','<lt>')..'<cr>', {noremap=true})
end end

return h
