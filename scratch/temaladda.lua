local a = vim.api
_G.a = vim.api
vim.cmd [[ color wip ]]
atema = a.nvim_create_namespace("temazo")
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

function on_win(_, win, buf, _topline, _botline)
  temat = (win == 1000) and btema or atema
  a.nvim_set_hl_ns(temat, true)
end

function on_line(_, win, buf, line)
  temat = (10 <= line and line < 20) and btema or atema
  a.nvim_set_hl_ns(temat, true)
end
a.nvim_set_decoration_provider(atema, {
    on_win=on_win;
    --on_line=on_line; -- too glitchy for now
})
