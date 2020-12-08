-- 2020 sunjon

local function get_time()
  return vim.fn.reltimefloat(vim.fn.reltime())
end

local ITERATIONS = 1000000
local start

local report = function(cmd_string, time)
  print(("%-20s %d iterations in %-.04f"):format(cmd_string, ITERATIONS, time))
end

local compare = {
  --{"vim.fn.asin(100)", "vim.api.nvim_call_function('asin', {100})"},
  --{"vim.fn.execute('let g:thing=1')", "vim.api.nvim_set_var('thing', 1)", "vim.cmd [[let g:thing=1]]"},
  {"vim.fn.setline(1, '--ro')", "vim.api.nvim_call_function('setline', {1, '--ro'})"},
}

for _, commands in ipairs(compare) do
  for _, cmd in pairs(commands) do
    start = get_time()
    local fun = loadstring(cmd)
    for i=1, ITERATIONS do
        fun()
    end
    report(cmd, get_time() - start)
  end
end
