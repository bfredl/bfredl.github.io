local M = {}
local vim,api = vim,vim.api


local function open_floating_preview(contents, filetype, opts)
  opts = opts or {}

  -- Clean up input: trim empty lines from the end, pad
  contents = vim.lsp.util._trim_and_pad(contents, opts)

  -- Compute size of float needed to show (wrapped) lines
  opts.wrap_at = opts.wrap_at or (vim.wo["wrap"] and api.nvim_win_get_width(0))
  local width, height = vim.lsp.util._make_floating_popup_size(contents, opts)

  local floating_bufnr = api.nvim_create_buf(false, true)
  if filetype then
    api.nvim_buf_set_option(floating_bufnr, 'filetype', filetype)
  end
  local float_option = vim.lsp.util.make_floating_popup_options(width, height, opts)
  local floating_winnr = api.nvim_open_win(floating_bufnr, false, float_option)
  if filetype == 'markdown' then
    api.nvim_win_set_option(floating_winnr, 'conceallevel', 2)
  end
  api.nvim_buf_set_lines(floating_bufnr, 0, -1, true, contents)
  api.nvim_buf_set_option(floating_bufnr, 'modifiable', false)
  vim.lsp.util.close_preview_autocmd({"CursorMoved", "CursorMovedI", "BufHidden", "BufLeave"}, floating_winnr)
  return floating_bufnr, floating_winnr
end

function M.jump_to()
  api.nvim_win_set_cursor(0,{4,3})
  open_floating_preview({"test"},'markdown')
end
m = M

return M
