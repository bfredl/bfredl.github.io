_G._moonwatch = _G._moonwatch or {}
local m = _G._moonwatch
local b = _G.bfredl
local sbuf, stage

m.ephemeral = m.ephemeral or {}

function m.float(args)
  m.prepare()
  if not args.relative then
    args.win = stage
  end
  args.focusable = args.focusable or false
  m.ephemeral[b.f(args)] = true
end

function m.cls()
  for w,_ in pairs(m.ephemeral) do
    if win.is_valid(w) then
      win.close(w, false)
    end
    m.ephemeral[w] = nil
  end
end
_G.cls = m.cls -- FIXME

function m.prepare()
  if not m.stage then
    local save = a.get_current_win()
    m.sbuf = a.create_buf(true, true)
    a.buf_set_name(m.sbuf, "[stage]")
    m.stage = b.f{buf=m.sbuf, enter=true}
    a.win_set_buf(m.stage, m.sbuf)
    vim.cmd [[wincmd H]]
    a.set_current_win(save)
  end
  stage, sbuf = m.stage, m.sbuf
end

function m.header(text)
  m.float {r=1, center='c', text=text}
end

m.Show = {}
local Show = m.Show
Show.__index = Show

function m.make_show(name, state)
  local self = setmetatable({}, Show)
  self.name = name
  self.slides = {}
  self.order = {}
  if state then
    self.cur = state.cur
  end
  return self
end

function Show:slide(key, fn)
  if self.slides[key] then
    error("duplicate "..key)
  end
  self.slides[key] = fn
  table.insert(self.order, key)
end

function Show:show(id)
  cls()
  id = id or self.order[1]
  self.slides[id]()
  self.cur = id
end

return m
