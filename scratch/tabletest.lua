local fun = function() print("reee") end
local table = setmetatable({}, {__call=function() print ("RAAAA") end})

print(vim.fn.timer_start(300, table))
