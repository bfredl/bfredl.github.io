extconceal = vim.api.nvim_create_namespace 'extconceal'
thebuf = vim.api.nvim_get_current_buf()
vim.cmd [[ set cole=2 ]]

function on_win(_, winid, bufnr, row)
  if bufnr ~= thebuf then
    return false -- FAIL
  end
end

function on_line(_, winid, bufnr, row)
  local indent = vim.fn.indent(row+1)
  vim.api.nvim_buf_set_extmark(bufnr, extconceal, row, 0, {
    end_col=indent, ephemeral=true, hl_group='ErrorMsg', conceal=''})
end
vim.api.nvim_set_decoration_provider(extconceal, {on_win=on_win, on_line=on_line})
