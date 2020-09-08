local a = vim.api
_G.a = vim.api
tema = a.nvim_create_namespace("temazo")

a.nvim__theme_def(tema, "EndOfBuffer", {background=1234})
a.nvim__theme_def(tema, "Statement", {background=100000, foreground=1234})

function thema_provide(_, ns_id, name)
  if name == "Identifier" then
    return {foreground=255*256}
  end
end
a.nvim__theme_set_provider(tema, thema_provide)

function raster_int(_, row, lastrow, size, win)
  if win == 1001 then
    a.nvim__theme_set(tema, true)
  else
    a.nvim__theme_set(0, true)
  end
end
a.nvim__set_raster_interrupt(raster_int)

