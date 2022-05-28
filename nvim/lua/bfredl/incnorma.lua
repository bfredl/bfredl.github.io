-- TODO: this should be simpler
plug_key = vim.api.nvim_replace_termcodes("<Plug>", true, true, true)

s_cursors = {}
countt = 0

function docursor()
  countt = countt + 1
  table.insert(s_cursors, vim.fn.getpos'.')
  return ''
end
vim.keymap.set({'', '!'}, "<Plug>(incnormal-cursor)", docursor)

function doit(opts)
  local cmd = opts.args
  if opts.is_preview then
    cmd = cmd .. plug_key .."(incnormal-cursor)"
  end
  vim.cmd {
    cmd = "normal";
    args = {cmd};
    bang = opts.bang;
    range = {opts.line1, opts.line2};
  }
end

function previewit(opts, ns, bufnr)
  opts.is_preview = true
  s_cursors = {}
  doit(opts)
  for _,c in ipairs(s_cursors) do
    vim.api.nvim_buf_add_highlight(0, ns, "IncCursor", c[2]-1, c[3]-1, c[3])
  end
  return 1
end

vim.cmd [[hi IncCursor cterm=reverse gui=reverse]]

vim.api.nvim_create_user_command("Norma", doit, {preview=previewit, nargs=1, bang=true, range=true})
