function doit(opts)
  vim.api.nvim_echo({{vim.inspect(opts)}}, true, {})
end

function previewit(opts, ns, bufnr)
  lenny = #opts.args
  vim.api.nvim_buf_set_extmark(0, ns, 0, 0, {end_col=lenny, hl_group="ErrorMsg"})
  --vim.api.nvim_echo({{"ahahaha"}}, true, {})
  return 1
end

vim.api.nvim_create_user_command("Norma", doit, {preview=previewit, nargs=1})

