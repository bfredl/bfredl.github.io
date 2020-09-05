_G._moonwatch = _G._moonwatch or {}
local h = _G._moonwatch
local b = _G.bfredl

h.ephemeral = {}

function h.float(args)
  h.ephemeral[b.f(args)] = true
end

function h.cls()
  for w,_ in pairs(h.ephemeral) do
    if win.is_valid(w) then
      win.close(w, false)
    end
    h.ephemeral[w] = nil
  end
end

return h
