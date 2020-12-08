local a = vim.api
_G.a = vim.api

vim.cmd [[ color wip ]]
atema = a.nvim_create_namespace("temazo")
adata = a.nvim__get_hl_defs(0)
for k,v in pairs(adata) do
  a.nvim_set_hl(atema, k, v)
end

vim.cmd [[ color gruvbox ]]
btema = a.nvim_create_namespace("jultema")
bdata = a.nvim__get_hl_defs(0)
for k,v in pairs(bdata) do
  a.nvim_set_hl(btema, k, v)
end

vim.cmd [[ color wip ]]

a.nvim_win_set_config(0, {hl_ns=btema})
--a.nvim_set_hl_ns(atema)

