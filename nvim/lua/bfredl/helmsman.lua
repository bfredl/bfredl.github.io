local h = _G._bfredl_helmsman or {}
_G._bfredl_helmsman = h
_G.hm = _G._bfredl_helmsman

local curl = require'plenary.curl'

h.API_TOKEN_HUG = os.getenv "hugtoken"
h.API_TOKEN_GOOSE = os.getenv "goosetoken"


function h.doer(url, api_token, input, cb)
  local tzero = vim.loop.gettimeofday()
  curl.post(url, {
    body = vim.fn.json_encode(input);
    headers = {
      Authorization = "Bearer "..api_token;
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

function h.testtext_hug(prompt, cb)
  local input = {
    inputs=prompt;
    options={use_cache=false;};
    parameters={
      top_p=0.9;
      repetition_penalty=1.9;
      max_new_tokens=250;
      max_time=30;
      num_return_sequences=3;
    };
  }
  model_name = "birgermoell/swedish-gpt"
  model_name = "flax-community/swe-gpt-wiki"
  model_name = "EleutherAI/gpt-neo-2.7B"
  return h.doer("https://api-inference.huggingface.co/models/"..model_name, h.API_TOKEN_HUG, input, cb)
end

function h.testtext_goose(prompt, cb)
  local input = {
    prompt=prompt;
    max_tokens=250;
    top_p=0.9;
    echo=true;
    repetition_penalty=1.9;
  }
  model_name = "gpt-neo-20b"
  return h.doer("https://api.goose.ai/v1/engines/"..model_name.."/completions", h.API_TOKEN_GOOSE, input, cb)
end

h.testtext = h.testtext_goose
h.testtext = h.testtext_hug

function h.dump_res(time, res)
  local print = require'luadev'.print
  print("RESULTS: ("..tostring(time).." s)\n")
  if res.choices then
    -- HONK
    for i,item in ipairs(res.choices) do
      if i > 1 then
        print("=======\n")
      end
      -- TODO: print fancy stuff using item.logprobs, like likeliness of each token?
      print(item.text)
    end
  else
    for i,item in ipairs(res) do
      if i > 1 then
        print("=======\n")
      end
      print(item.generated_text)
    end
  end
  print("=FIN=\n")
end

function h.trigger(text)
  local print = require'luadev'.print
  print("trigger the text "..vim.inspect(text))
  h.testtext(text, vim.schedule_wrap(function(time, res, err)
    if err ~= nil then
      return error("FÄÄÄääLLL "..tostring(err)..'\n'..tostring(res))
    end
    h.rawres = res
    local r = vim.fn.json_decode(res)
    h.dump_res(time, r)
  end))
end


function h.visual()
  local text = vim.fn["bfredl#get_selection"](false)
  h.trigger(text)
end

function h.file()
  local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  h.trigger(text)
end

function h.buffermap()
  vim.cmd [[vnoremap <buffer> <plug>ch:un :<c-u>lua require'bfredl.helmsman'.visual()<cr>]]
  vim.cmd [[nmap <buffer> <plug>ch:un V<plug>ch:un]]
  vim.cmd [[nnoremap <buffer> <plug>ch:uc :<c-u>lua require'bfredl.helmsman'.file()<cr>]]
end


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