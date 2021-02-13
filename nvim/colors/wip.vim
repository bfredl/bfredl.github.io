" WIP by Björn Linse
" Created: after too much coffe getrunken
" License: MIT
" Blah:    blah-blah
"
" Contains code derived from Solarized by Ethan Schoonover

" Colorscheme initialization "{{{
" ---------------------------------------------------------------------
hi clear
if exists("syntax_on")
  syntax reset
endif
let colors_name = "wip"
set background=dark

"}}}
" color definitions "{{{

" magic keyword: DO NOT CHANGE FORMATING UNTIL "}"
" but happily change/add colors :D

""COLORDEF
let s:colors = {
    \ "dark2":       [ "#0c1014", "234"],
    \ "dark1":       [ "#1d1d24", "233"],
    \ "dark0":       [ "#303030", "236"],
    \ "darkgray":    [ "#383838", "238"],
    \ "midgray":     [ "#4a4a58", "227"],
    \ "mgray":       [ "#606060", "241"],
    \ "gray":        [ "#808080", "239"],
    \ "ltext":       [ "#909090", "240"],
    \ "text":        [ "#bbbbbb", "210"],
    \ "bright":      [ "#dddddd", "211"],
    \ "dblue":       [ "#141820", "235"],
    \ "dblue2":      [ "#101418", "212"],
    \ "mblue":       [ "#282858", "237"],
    \ "gblue":       [ "#2838a8", "220"],
    \ "pblue":       [ "#565690", "144"],
    \ "blue":        [ "#6676ff", "145"],
    \ "cblue":       [ "#2222dd", "148"],
    \ "cyan":        [ "#26a0b9", "146"],
    \ "orange":      [ "#c06018", "140"],
    \ "dgreen":      [ "#104020", "150"],
    \ "green":       [ "#10a020", "152"],
    \ "yellow":      [ "#939300", "154"],
    \ "deepred":     [ "#601818", "153"],
    \ "violet":      [ "#580098", "155"],
    \ "dviolet":     [ "#20182a", "156"],
    \ "ultragray":   [ "#6e6e80", "157"]
    \ }
"

"}}}
" Highlighting primitives"{{{
" ---------------------------------------------------------------------
"
let s:none            = "NONE"
let s:c               = ",undercurl"
let s:r               = ",reverse"
let s:s               = ",standout"
let s:ou              = ""
let s:ob              = ""

" replace w/ emtpy string to disable
let s:b           = ",bold"
let s:u           = ",underline"
let s:i           = ",italic"
"let s:i           = ""

if (has("gui_running")) || &termguicolors
    let s:vmode       = "gui"
    let s:ind = 0
    let s:is_gui = 1
"let s:green       = "#859900" "original
else
    let s:vmode       = "cterm"
    let s:ind = 1
    let s:is_gui = 0
endif

for [nam, def] in items(s:colors)
    exe "let s:".nam." = '".def[s:ind]."'"
    exe "let g:sol_".nam." = '".def[s:ind]."'"
    exe "let s:bg_".nam." = ' ".s:vmode."bg=".def[s:ind] ."'"
    exe "let s:fg_".nam." = ' ".s:vmode."fg=".def[s:ind] ."'"
    if s:is_gui
        exe "let s:sp_".nam."      = ' guisp=".def[s:ind]   ."'"
    else
        exe "let s:sp_".nam."      = ''"
    endif
endfor


exe "let s:bg_none      = ' ".s:vmode."bg=".s:none   ."'"
exe "let s:bg_back      = ' ".s:vmode."bg=".s:none   ."'"

exe "let s:fg_none      = ' ".s:vmode."fg=".s:none   ."'"
exe "let s:fg_back      = ' ".s:vmode."fg=".s:none   ."'"

exe "let s:fmt_none     = ' ".s:vmode."=NONE".          " term=NONE".    "'"
exe "let s:fmt_bold     = ' ".s:vmode."=NONE".s:b.      " term=NONE".s:b."'"
exe "let s:fmt_bldi     = ' ".s:vmode."=NONE".s:b.      " term=NONE".s:b."'"
exe "let s:fmt_undr     = ' ".s:vmode."=NONE".s:u.      " term=NONE".s:u."'"
exe "let s:fmt_undb     = ' ".s:vmode."=NONE".s:u.s:b.  " term=NONE".s:u.s:b."'"
exe "let s:fmt_undi     = ' ".s:vmode."=NONE".s:u.      " term=NONE".s:u."'"
exe "let s:fmt_uopt     = ' ".s:vmode."=NONE".s:ou.     " term=NONE".s:ou."'"
exe "let s:fmt_curl     = ' ".s:vmode."=NONE".s:c.      " term=NONE".s:c."'"
exe "let s:fmt_ital     = ' ".s:vmode."=NONE".s:i.      " term=NONE".s:i."'"
exe "let s:fmt_stnd     = ' ".s:vmode."=NONE".s:s.      " term=NONE".s:s."'"
exe "let s:fmt_revr     = ' ".s:vmode."=NONE".s:r.      " term=NONE".s:r."'"
exe "let s:fmt_revb     = ' ".s:vmode."=NONE".s:r.s:b.  " term=NONE".s:r.s:b."'"
" these were "bold in primitive terminals"
exe "let s:fmt_revbb    = ' ".s:vmode."=NONE".s:r.   " term=NONE".s:r."'"
exe "let s:fmt_revbbu   = ' ".s:vmode."=NONE".s:r.s:u." term=NONE".s:r.s:u."'"

"}}}
" UI highlighting"{{{
exe "hi! Normal"         .s:fmt_none   .s:fg_text  .s:bg_dark2
exe "hi! LineNr"         .s:fmt_none   .s:fg_pblue  .s:bg_dblue
exe "hi! Folded"         .s:fmt_undb   .s:fg_dark2  .s:bg_mgray
"exe "hi! FoldColumn"     .s:fmt_none   .s:fg_base0  .s:bg_base02
exe "hi! Search"         .s:fmt_revr   .s:fg_orange .s:bg_none
exe "hi! Cursor"         .s:fmt_none   .s:fg_dark2 .s:bg_orange
exe "hi! SignColumn"     .s:fmt_none   .s:fg_text  .s:bg_dblue
exe "hi! MatchParen"     .s:fmt_bold   .s:fg_text    .s:bg_deepred
exe "hi! Conceal"        .s:fmt_none   .s:fg_orange   .s:bg_none
exe "hi! SpecialKey"     .s:fmt_bold   .s:fg_blue .s:bg_darkgray
hi! link Whitespace SpecialKey
exe "hi! Wildmenu"     .s:fmt_bold   .s:fg_bright .s:bg_violet
"exe "hi! EndOfBuffer"     .s:fmt_bold   .s:fg_mgray .s:bg_dblue2
exe "hi! EndOfBuffer"     .s:fmt_bold   .s:fg_midgray .s:bg_dark1

if v:true
" better colors for 'pumblend'
exe "hi! Pmenu"         .s:fmt_none   .s:fg_text  .s:bg_mblue
exe "hi! PmenuSel"      .s:fmt_none   .s:fg_bright  .s:bg_gblue
exe "hi! PmenuSbar"      .s:fmt_none   .s:fg_text  .s:bg_mgray
exe "hi! PmenuThumb"      .s:fmt_none   .s:fg_text  .s:bg_deepred
else
exe "hi! Pmenu"         .s:fmt_none   .s:fg_dblue  .s:bg_ltext
exe "hi! PmenuSel"      .s:fmt_none   .s:fg_bright  .s:bg_violet
exe "hi! PmenuSbar"      .s:fmt_none   .s:fg_text  .s:bg_mgray
exe "hi! PmenuThumb"      .s:fmt_none   .s:fg_text  .s:bg_cblue
end
exe "hi! MsgSeparator"      .s:fmt_none   .s:fg_text  .s:bg_ultragray . " blend=30"
exe "hi! MsgArea"      .s:fmt_none   .s:fg_text  .s:bg_dviolet . " blend=15"

exe "hi DiffChange"      .s:fmt_none   .s:fg_text  .s:bg_darkgray
exe "hi DiffText"        .s:fmt_none   .s:fg_text  .s:bg_pblue
exe "hi DiffAdd"        .s:fmt_none   .s:fg_text  .s:bg_gblue
exe "hi DiffDelete"        .s:fmt_none   .s:fg_bright  .s:bg_gblue
" }}}
" Syntax highlighting"{{{
exe "hi! Comment"        .s:fmt_ital   .s:fg_blue   .s:bg_none
exe "hi! String"        .s:fmt_none   .s:fg_blue   .s:bg_dblue
exe "hi! Constant"        .s:fmt_none   .s:fg_blue   .s:bg_none
exe "hi! Boolean"        .s:fmt_bold   .s:fg_blue   .s:bg_none
exe "hi! Statement"      .s:fmt_bold   .s:fg_yellow  .s:bg_none
exe "hi! PreProc"        .s:fmt_none   .s:fg_mgray  .s:bg_none
exe "hi! Identifier"     .s:fmt_bold   .s:fg_cyan   .s:bg_none
exe "hi! Type"           .s:fmt_bold   .s:fg_green .s:bg_none
exe "hi! UserType"       .s:fmt_none   .s:fg_cyan .s:bg_none
exe "hi! PythonSelf"     .s:fmt_bold   .s:fg_deepred  .s:bg_none
" }}}
" Haskell highlighting {{{
" assuming vim2hs syntax
hi link hsStructure Statement
hi link hsImport PreProc
hi link hsImportKeyword PreProc
hi link hsDelimiter Normal
" }}}
" Utility auto stuff "{{{
autocmd GUIEnter * if (s:vmode != "gui") | exe "colorscheme " . g:colors_name | endif
if 0
    noremap <Plug>ch:am :w<cr>:color wip<cr>:set mouse<cr>
end
"}}}
" License "{{{
" ---------------------------------------------------------------------
"
" Copyright (c) 2011 Ethan Schoonover, 2014 Björn Linse

"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
"
" vim:foldmethod=marker:foldlevel=0
"}}}
