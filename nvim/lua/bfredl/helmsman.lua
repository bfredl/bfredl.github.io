local h = {}
local curl = require'plenary.curl'

h.API_TOKEN = os.getenv "hugtoken"

function h.doit(input, cb)
  local res = curl.post("https://api-inference.huggingface.co/models/EleutherAI/gpt-neo-2.7B", {
    body = vim.fn.json_encode(input);
    headers = {
      Authorization = "Bearer "..h.API_TOKEN;
    };
    callback = function(res)
      if res.status ~= 200 then
        cb(nil, res.status)
      else
        cb(res.body, nil)
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

-- FUBBIT
_G.h = h

h.testtext("void win_line(win_T *wp, linenr_T lnum)\n{\n", vim.schedule_wrap(function(res, err)
  local print = require'luadev'.print
  if err ~= nil then
    return error("ÄRROR "..tostring(err))
  end
  print("RESULTS:\n")
  for _,item in ipairs(vim.fn.json_decode(res)) do
    print("=======\n")
    print(item.generated_text)
  end
end))


return h
