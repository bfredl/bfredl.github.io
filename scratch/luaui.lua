vim.ui_attach({ext_popupmenu=true}, function (a, ...)
  require'luadev'.print(a, vim.inspect{...})
end)

