local a = vim.api
_G.a = vim.api
tema = a.nvim_create_namespace("temazo")

a.nvim_set_highlight(tema, "EndOfBuffer", {background=1234})
a.nvim_set_highlight(tema, "Statement", {background=100000, foreground=1234})
a.nvim_set_highlight(tema, "Identifier", {link="ErrorMsg"})
a.nvim_set_highlight(tema, "Identifier", {bold=true})

a.nvim_set_hl_ns(tema, false)
a.nvim_set_theme(0, false)
