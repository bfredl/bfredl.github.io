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
    end
  })
end

function h.testtext(prompt, cb)
  local input = {
    inputs=prompt;
    options={use_cache=false;};
    parameters={
      top_p=0.9;
      repetition_penalty=1.9;
      max_new_tokens=250;
      max_time=30;
      num_return_sequences=1;
    };
  }
  return h.doit(input, cb)
end

-- FUBBIT
_G.h = h

h.testtext("Give me some good news!", vim.schedule_wrap(function(res, err)
  require'luadev'.print(res)
  require'luadev'.print(err)
end))


return h
