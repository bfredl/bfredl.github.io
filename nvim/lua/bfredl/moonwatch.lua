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

return m
