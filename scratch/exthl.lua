-- Test
local api = vim.api

local function exthighlight(bufnr, ns, higroup, start, finish, rtype, inclusive, priority)
  rtype = rtype or 'v'
  inclusive = inclusive or false
  priority = priority or 50

  -- sanity check
  if start[2] < 0 or finish[1] < start[1] then return end

  local region = vim.region(bufnr, start, finish, rtype, inclusive)
  for linenr, cols in pairs(region) do
    local end_row
    if cols[2] == -1 then
      end_row = linenr + 1
      cols[2] = 0
    end
    api.nvim_buf_set_extmark(bufnr, ns, linenr, cols[1], {
      hl_group = higroup,
      end_row = end_row,
      end_col = cols[2],
      priority = priority
    })
  end

end

local function highlight(bufnr, ns, higroup, start, finish, rtype, inclusive)
  rtype = rtype or 'v'
  inclusive = inclusive or false

  -- sanity check
  if start[2] < 0 or finish[1] < start[1] then return end

  local region = vim.region(bufnr, start, finish, rtype, inclusive)
  for linenr, cols in pairs(region) do
    api.nvim_buf_add_highlight(bufnr, ns, higroup, linenr, cols[1], cols[2])
  end

end

local bufnr = 0
local yank_ns = api.nvim_create_namespace('hlyank')
api.nvim_buf_clear_namespace(bufnr, yank_ns, 0, -1)

local higroup = "IncSearch"
--exthighlight(bufnr, yank_ns, higroup, { 0,0 }, { 0, 10 }, nil, nil, 40)
highlight(bufnr, yank_ns, higroup, { 0,0 }, { 0,10 }, nil, nil)
