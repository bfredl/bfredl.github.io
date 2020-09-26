local a = vim.api
_G.a = vim.api
atema = a.nvim_create_namespace("temazo")
vim.cmd [[ color wip ]]
adata = a.nvim_get_hl_defs(0)
for k,v in pairs(adata) do
  a.nvim_set_highlight(atema, k, v)
end

vim.cmd [[ color gruvbox ]]
btema = a.nvim_create_namespace("jultema")
bdata = a.nvim_get_hl_defs(0)
for k,v in pairs(bdata) do
  a.nvim_set_highlight(btema, k, v)
end

vim.cmd [[ color wip ]]
a.nvim_set_hl_ns(atema, false)
a.nvim_set_hl_ns(btema, false)

function on_win(_, win, buf, _topline, _botline)
  temat = (win == 1000) and btema or atema
  a.nvim_set_hl_ns(temat, true)
end
a.nvim_set_decoration_provider(atema, {on_win=on_win})


a.nvim_set_hl_ns(tema, false)
a.nvim_set_theme(0, false)
