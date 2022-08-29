ns = a.create_namespace'my_fancy_pum'
vim.ui_attach(ns, {ext_popupmenu=true}, function (event, ...)
  if event == "popupmenu_show" then
    local items, selected, row, col, grid = ...
    print("display pum ", #items)
  elseif event == "popupmenu_select" then
    local selected = ...
    print("selected", selected)
  elseif event == "popupmenu_hide" then
    print("FIN")
  end
end)
