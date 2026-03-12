 vim.cmd 'hi clear'

local H = require'mini.hues'
_G.MiniHues = H

local config = {
  background='#151522';
  foreground='#dee2f1';
  saturation = 'high';
  accent = 'blue';
  plugins = {default = true};
}

local opts = { autoadjust = config.autoadjust }
local palette = MiniHues.make_palette(config)
_G.palette = palette
--MiniHues.apply_palette(palette, config.plugins, opts)

local hi = function(name, data) vim.api.nvim_set_hl(0, name, data) end
local p = palette

p.green = '#a6ff82'
p.greenl = '#a2f080'
p.yellow_mid = '#eed873'

if true then
  hi('ColorColumn',    { fg=nil,       bg=p.bg_mid2 })
  hi('ComplMatchIns',  { fg=nil,       bg=nil })
  hi('Conceal',        { fg=p.azure,   bg=nil })
  hi('CurSearch',      { fg=p.bg,      bg=p.yellow })
  hi('Cursor',         { fg=p.bg,      bg=p.fg })
  hi('CursorColumn',   { fg=nil,       bg=p.bg_mid })
  hi('CursorIM',       { link='Cursor' })
  hi('CursorLine',     { fg=nil,       bg=p.bg_mid })
  hi('CursorLineFold', { fg=p.bg_mid2, bg=nil })
  hi('CursorLineNr',   { fg=p.accent,  bg=nil,       bold=true })
  hi('CursorLineSign', { fg=p.bg_mid2, bg=nil })
  hi('DiffAdd',        { fg=nil,       bg=p.green_bg })
  hi('DiffChange',     { fg=nil,       bg=p.cyan_bg })
  hi('DiffDelete',     { fg=nil,       bg=p.red_bg })
  hi('DiffText',       { fg=nil,       bg=p.yellow_bg })
  hi('DiffTextAdd',    { link='DiffAdd' })
  hi('Directory',      { fg=p.azure,   bg=nil })
  hi('EndOfBuffer',    { fg=p.bg_mid2, bg=nil })
  hi('ErrorMsg',       { fg=p.red,     bg=nil })
  hi('FloatBorder',    { fg=p.accent,  bg=p.bg_edge })
  hi('FloatTitle',     { fg=p.accent,  bg=p.bg_edge, bold=true })
  hi('FoldColumn',     { fg=p.bg_mid2, bg=nil })
  hi('Folded',         { fg=p.fg_mid2, bg=p.bg_edge })
  hi('IncSearch',      { fg=p.bg,      bg=p.yellow })
  hi('lCursor',        { fg=p.bg,      bg=p.fg })
  hi('LineNr',         { fg=p.bg_mid2, bg=nil })
  hi('LineNrAbove',    { link='LineNr' })
  hi('LineNrBelow',    { link='LineNr' })
  hi('MatchParen',     { fg=nil,       bg=p.bg_mid2, bold=true })
  hi('ModeMsg',        { fg=p.green,   bg=nil })
  hi('MoreMsg',        { fg=p.azure,   bg=nil })
  hi('MsgArea',        { link='Normal' })
  -- hi('MsgSeparator',   H.attr_msgseparator(p, autoadjust))
  hi('NonText',        { fg=p.bg_mid2, bg=nil })
  hi('Normal',         { fg=p.fg,      bg=p.bg })
  hi('NormalFloat',    { fg=p.fg,      bg=p.bg_edge })
  hi('NormalNC',       { link='Normal' })
  hi('OkMsg',          { fg=p.green,   bg=nil })
  -- hi('Pmenu',          H.attr_pmenu(p, autoadjust))
  hi('PmenuBorder',    { link='Pmenu' })
  hi('PmenuExtra',     { link='Pmenu' })
  hi('PmenuExtraSel',  { link='PmenuSel' })
  hi('PmenuKind',      { link='Pmenu' })
  hi('PmenuKindSel',   { link='PmenuSel' })
  hi('PmenuMatch',     { fg=nil,       bg=nil,       bold=true })
  hi('PmenuMatchSel',  { fg=nil,       bg=nil,       bold=true,   blend=0, reverse=true })
  hi('PmenuSbar',      { link='Pmenu' })
  hi('PmenuSel',       { fg=nil,       bg=nil,       blend=0,     reverse=true })
  hi('PmenuThumb',     { fg=nil,       bg=p.bg_mid2 })
  hi('Question',       { fg=p.azure,   bg=nil })
  hi('QuickFixLine',   { fg=nil,       bg=nil,       bold=true })
  hi('Search',         { fg=p.bg,      bg=p.accent })
  hi('SignColumn',     { fg=p.bg_mid2, bg=nil })
  hi('SpecialKey',     { fg=p.bg_mid2, bg=nil })
  hi('SpellBad',       { fg=nil,       bg=nil,       sp=p.red,    undercurl=true })
  hi('SpellCap',       { fg=nil,       bg=nil,       sp=p.cyan,   undercurl=true })
  hi('SpellLocal',     { fg=nil,       bg=nil,       sp=p.yellow, undercurl=true })
  hi('SpellRare',      { fg=nil,       bg=nil,       sp=p.blue,   undercurl=true })
  hi('StatusLine',     { fg=p.fg_mid,  bg=p.accent_bg })
  hi('StatusLineNC',   { fg=p.fg_mid,  bg=p.bg_edge })
  hi('StderrMsg',      { link='ErrorMsg' })
  hi('StdoutMsg',      { link='MsgArea' })
  hi('Substitute',     { fg=p.bg,      bg=p.blue })
  hi('TabLine',        { fg=p.fg_mid,  bg=p.bg_edge })
  hi('TabLineFill',    { link='Tabline' })
  hi('TabLineSel',     { fg=p.accent,  bg=p.bg_edge })
  hi('TermCursor',     { fg=nil,       bg=nil,       reverse=true })
  hi('TermCursorNC',   { fg=nil,       bg=nil,       reverse=true })
  hi('Title',          { fg=p.accent,  bg=nil })
  hi('VertSplit',      { fg=p.accent,  bg=nil })
  hi('Visual',         { fg=nil,       bg=p.bg_mid2 })
  hi('VisualNOS',      { fg=nil,       bg=p.bg_mid })
  hi('WarningMsg',     { fg=p.yellow,  bg=nil })
  hi('Whitespace',     { fg=p.bg_mid2, bg=nil })
  hi('WildMenu',       { link='PmenuSel' })
  hi('WinBar',         { link='StatusLine' })
  hi('WinBarNC',       { link='StatusLineNC' })
  hi('WinSeparator',   { fg=p.accent,  bg=nil })
end

if true then
  -- p=palette
  -- syntax highlighting. more based on the wip/sitruuna_bfredl style but reconstructed using mini.hues
  hi('Type',           { fg=p.green,      bg=nil })
  hi('@type.builtin',  { fg=p.greenl,      bg=nil, bold=true })
  hi('@keyword.modifier',  { fg=p.greenl,      bg=nil, bold=true })
  hi('Constant',  { fg=p.blue,      bg=nil })
  hi('@constant.builtin',  { fg=p.blue,      bg=nil })
  hi('Identifier',  { fg=p.azure,      bg=nil })
  hi('Function',  { fg=nil,      bg=nil })
  hi('String',  { fg=nil,      bg=p.blue_bg })
  hi('Statement',  { fg=p.yellow_mid,      bg=nil, bold=true })
  hi('Special',  { fg=p.azure,      bg=nil, bold=true })
end

if true then
  hi('GitSignsAdd',             { fg=p.green,  bg=nil })
  hi('GitSignsAddLn',           { link='GitSignsAdd' })
  hi('GitSignsAddInline',       { link='GitSignsAdd' })

  hi('GitSignsChange',          { fg=p.accent, bg=nil })
  hi('GitSignsChangeLn',        { link='GitSignsChange' })
  hi('GitSignsChangeInline',    { link='GitSignsChange' })

  hi('GitSignsDelete',          { fg=p.red,    bg=nil })
  hi('GitSignsDeleteLn',        { link='GitSignsDelete' })
  hi('GitSignsDeleteInline',    { link='GitSignsDelete' })

  hi('GitSignsUntracked',       { fg=p.azure,  bg=nil })
  hi('GitSignsUntrackedLn',     { link='GitSignsUntracked' })
  hi('GitSignsUntrackedInline', { link='GitSignsUntracked' })
end

if true then
  hi('MiniStatuslineDevinfo',     { fg=p.fg_mid, bg=p.bg_mid })
  hi('MiniStatuslineFileinfo',    { link='MiniStatuslineDevinfo' })
  hi('MiniStatuslineFilename',    { fg=p.fg_mid, bg=p.accent_bg })
  hi('MiniStatuslineInactive',    { link='StatusLineNC' })
  hi('MiniStatuslineModeCommand', { fg=p.bg,     bg=p.yellow, bold=true })
  hi('MiniStatuslineModeInsert',  { fg=p.bg,     bg=p.azure,  bold=true })
  hi('MiniStatuslineModeNormal',  { fg=p.bg,     bg=p.fg,     bold=true })
  hi('MiniStatuslineModeOther',   { fg=p.bg,     bg=p.cyan,   bold=true })
  hi('MiniStatuslineModeReplace', { fg=p.bg,     bg=p.red,    bold=true })
  hi('MiniStatuslineModeVisual',  { fg=p.bg,     bg=p.green,  bold=true })
end


vim.api.nvim_set_hl(0, '@lsp.type.macro', {})
vim.api.nvim_set_hl(0, '@constructor.lua', {})
vim.api.nvim_set_hl(0, 'Delimiter', {})


--require('mini.colors').interactive()

