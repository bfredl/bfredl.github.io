miniguide = vim.api.nvim_create_namespace 'miniguide'
function on_win(_, winid, bufnr, row)
  if bufnr ~= vim.api.nvim_get_current_buf() then
    return false -- FAIL
  end
end

function on_line(_, winid, bufnr, row)
  local indent = vim.fn.indent(row+1)
  for i = 1, indent-1, 2 do
    vim.api.nvim_buf_set_extmark(bufnr, miniguide, row, i-1, {
      virt_text={{"│", "Statement"}}, virt_text_pos="overlay", ephemeral=true})
    if tata then
      ree = re
    end
  end
end
vim.api.nvim_set_decoration_provider(miniguide, {on_win=on_win, on_line=on_line})
