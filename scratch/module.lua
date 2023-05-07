local M = {}
_G.tt = M


function M.test() -- {{{
  local a = {}
  a.t = true
  function a.change_t() -- {{{
    a.t = false
  end
  function a.main()
      if not a.t then
          print(1)
      end
  end
  return a
  -- }}}
end
-- }}}


return M
