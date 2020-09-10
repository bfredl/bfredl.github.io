
function putta(_,a,b,c,d)
    vim.schedule(function() require'luadev'.print(vim.inspect({a,b,c,d})) end)
    d.background = 3000
    return d
end

vim.api.nvim__putta(putta)
