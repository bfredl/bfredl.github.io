a = vim.api
ltema = a.nvim_create_namespace "ltema"

function on_win(nam, win, buf, top, max)
    a.nvim_set_theme((win == 1000) and ltema or 0, true)
    return true
  --vim.api.nvim__put_attr(num, 3, {end_col=8, hl_group="ErrorMsg", virt_text={{"halloj", "Comment"}}})
end

function on_line(nam, win, buf, num)
  a.nvim_set_theme(((num == 3) and ltema) or 0, true)
  if num == 3 then
    vim.schedule(function() require'luadev'.print("uu") end)
  end
  --vim.api.nvim__put_attr(num, 3, {end_col=8, hl_group="ErrorMsg", virt_text={{"halloj", "Comment"}}})
end

a.nvim_set_highlight(ltema, "LineNr", {background=5234})
a.nvim_set_highlight(ltema, "String", {foreground=256*240, bold=true, standout=true})
vim.api.nvim_set_decoration_provider(ltema, {on_win=on_win, on_line=on_line})
a.nvim_set_theme(0, false)

function aa()
end
aa()
