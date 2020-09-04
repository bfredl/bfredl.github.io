function doit(nam, win, buf, num)
  vim.api.nvim__put_attr(num, 3, {end_col=8, hl_group="ErrorMsg", virt_text={{"halloj", "Comment"}}})
end

function aa()
  vim.api.nvim__buf_set_luahl(0, {on_line=doit})
end
aa()
