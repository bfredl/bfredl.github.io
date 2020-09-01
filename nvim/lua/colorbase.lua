-- borrowed from norcallis lua pile
local function highlight(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  local parts = {group}
  if guifg then table.insert(parts, "guifg=#"..guifg) end
  if guibg then table.insert(parts, "guibg=#"..guibg) end
  if ctermfg then table.insert(parts, "ctermfg="..ctermfg) end
  if ctermbg then table.insert(parts, "ctermbg="..ctermbg) end
  if attr then
    table.insert(parts, "gui="..attr)
    table.insert(parts, "cterm="..attr)
  end
  if guisp then table.insert(parts, "guisp=#"..guisp) end

  -- nvim.ex.highlight(parts)
  vim.api.nvim_command('highlight '..table.concat(parts, ' '))
end
