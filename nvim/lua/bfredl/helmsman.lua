local h = {}
local curl = require'plenary.curl'

h.API_TOKEN = os.getenv "hugtoken"


function h.doit(input, cb)
  local tzero = vim.loop.gettimeofday()
  local res = curl.post("https://api-inference.huggingface.co/models/EleutherAI/gpt-neo-2.7B", {
    body = vim.fn.json_encode(input);
    headers = {
      Authorization = "Bearer "..h.API_TOKEN;
    };
    callback = function(res)
      local time = vim.loop.gettimeofday() - tzero
      if res.status ~= 200 then
        cb(time, nil, res.status)
      else
        cb(time, res.body, nil)
      end
    end;
  })
end

function h.testtext(prompt, cb)
  local input = {
    inputs=prompt;
    options={use_cache=false;};
    parameters={
      top_p=0.9;
      repetition_penalty=1.9;
      max_new_tokens=80;
      max_time=30;
      num_return_sequences=3;
    };
  }
  return h.doit(input, cb)
end

function h.dump_res(time, res)
  local print = require'luadev'.print
  print("RESULTS: ("..tostring(time)..")\n")
  for i,item in ipairs(res) do
    if i > 1 then
      print("=======\n")
    end
    print(item.generated_text)
  end
  print("=FIN=\n")
end

function h.visual()
  local print = require'luadev'.print
  local text = vim.fn["bfredl#get_selection"](false)
  print("trigger the text "..vim.inspect(text))
  h.testtext(text, vim.schedule_wrap(function(time, res, err)
    if err ~= nil then
      return error("FÄÄÄääLLL "..tostring(err))
    end
    local r = vim.fn.json_decode(res)
    h.dump_res(time, r)
  end))
end

vim.cmd [[vnoremap <plug>ch:ht :<c-u>lua require'bfredl.helmsman'.visual()<cr>]]


-- FUBBIT
_G.h = h

if false then
  h.testtext("void nvim_command(String command, Error *err)\n{\n", vim.schedule_wrap(function(time, res, err)
    if err ~= nil then
      return error("ÄRROR "..tostring(err))
    end
    h.dump_res(time, vim.fn.json_decode(res))
  end))
end


return h
