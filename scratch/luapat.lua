function lua_omnifunc(find_start, find_pos)
  assert(find_start == 1)
  line = vim.api.nvim_get_current_line()
  prefix = string.sub(line, 1, vim.api.nvim_win_get_cursor(0)[2])
  matches, pos = vim._expand_pat(prefix)
  if #matches > 0 then
    -- TODO(bfredl): this should work without schedule_wrap
    vim.schedule_wrap(vim.fn.complete)(pos+1, matches)
    return -2
  else
    return -1
  end
end

do local matches
  function lua_omnifunc2(find_start, find_pos)
    if find_start == 1 then
      local line = vim.api.nvim_get_current_line()
      local prefix, pos = string.sub(line, 1, vim.api.nvim_win_get_cursor(0)[2])
      matches, pos = vim._expand_pat(prefix)
      if #matches > 0 then
        -- TODO(bfredl): this should work without schedule_wrap
        return pos
      else
        return -1
      end
    else
      return matches
    end
  end
end

