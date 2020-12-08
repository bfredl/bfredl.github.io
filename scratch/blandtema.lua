local a = vim.api
local x = 3
_G.a = vim.api
atema = a.nvim_create_namespace 'blanda'

a.nvim_set_hl(atema, "Statement", {link="LineNr"})
a.nvim_set_hl(atema, "String", {global_link="Statement"})
a.nvim_win_set_config(0, {hl_ns= atema})
