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

vim.cmd [[ color sitruuna ]]

function on_win(_, win, buf, _topline, _botline)
  temat = (win == 1000) and btema or atema
  a.nvim_set_hl_ns_fast(temat)
end

function on_line(_, win, buf, line)
  temat = (10 <= line and line < 20) and btema or atema
  a.nvim_set_hl_ns_fast(temat)
end
function on_end(_)
  a.nvim_set_hl_ns_fast(0)
end
a.nvim_set_decoration_provider(atema, {
    on_win=on_win;
    --on_line=on_line; -- too glitchy for now
    on_end=on_end;
})
