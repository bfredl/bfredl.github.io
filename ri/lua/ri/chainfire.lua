local ri = _G.ri
local chainfire = ri.chainfire or {}
ri.chainfire = chainfire

local ft = {}
chainfire.ft = ft

function bmapmode(mode)
  return function(lhs)
    return function(rhs)
      return a.nvim_buf_set_keymap(0, mode, lhs, rhs, {noremap=true})
    end
  end
end
local bimap = bmapmode'i'
function ft.c()
  bimap '¶)' ')'
  bimap '¶,' ','
  bimap '¶<space>' '<space>'
  bimap '¶' '<space>'
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup("RiChainFire", { clear = true });
  callback = function(ev)
    local func = ft[ev.match]
    if func then func() end
  end
})

return chainfire
