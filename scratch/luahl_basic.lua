a = vim.api
ltema = a.nvim_create_namespace("ltema")

a.nvim_set_highlight(ltema, "LineNr", {background=1234})
a.nvim_set_highlight(ltema, "String", {foreground=256*240, bold=true, standout=true})
a.nvim_set_theme(ltema, false)
