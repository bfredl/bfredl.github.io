local M = {}
function M.check_it()
  local rtp = vim.o.rtp
  local cached = vim.api.nvim__runtime_inspect()
  for _,item in ipairs(cached) do
    print(vim.inspect(item))
    local pos = item[5]+1
    -- print ("checka:", string.sub(rtp, pos-1, pos-1))
    if pos > 1 and string.sub(rtp, pos-1, pos-1) ~= "," then
      print "WEIRD FAIL"
    end
    local next_pos = string.find(rtp, ",", pos, true)
    local sub = string.sub(rtp, pos, next_pos and (next_pos-1))
    if (sub == item[1]) then
      print("AXACT")
    else
      print ("is from:", sub)
    end
  end
end
return M
