" sitruuna.vim
" A fresh lemon inspired colorscheme for vim

" Setup {{{
hi clear
if exists("syntax_on")
  syntax reset
endif
set background=dark
let g:colors_name="sitruuna"
" }}}
" Colors {{{
let s:col            = {}
let s:col.lemon      = ['#FAC03B', 220]
let s:col.special    = ['#ffb354', 215]
let s:col.preproc    = ['#a2abae', 147]
let s:col.type       = ['#a3db81', 117]
let s:col.sparkly    = ['#e2e2e2', 188]
let s:col.foreground = ['#d1d1d1', 188]
let s:col.fg_alt     = ['#a1a1a1', 145]
let s:col.fg_dark    = ['#919191', 145]
let s:col.statusline = ['#34373a', 137]
let s:col.darker     = ['#131515', 232]
let s:col.background = ['#1c2438', 233]
let s:col.darkbg     = ['#182024', 233]
let s:col.linenrbg   = ['#303050', 233]
let s:col.signbg     = ['#505080', 233]
let s:col.light_bg   = ['#1d2023', 236]
let s:col.lighter_bg = ['#242629', 238]
let s:col.cline_bg   = ['#303040', 238]
let s:col.selection  = ['#606870', 238]
let s:col.msgsep     = ['#808080', 238]
let s:col.trailwhite = ['#707070', 238]
let s:col.comment    = ['#94a0d8', 244]
let s:col.string     = ['#8b94e6', 72]
let s:col.stringbg   = ['#292b40', 136]
let s:col.function   = ['#68d0d8', 104]
let s:col.lightfun   = ['#98a0d8', 104]
let s:col.constant   = ['#ca70d6', 170]
let s:col.error      = ['#c15959', 131]
let s:col.pmenu      = ['#281855', 236]
let s:col.none       = ['NONE', 'NONE']
" }}}
" Highlighting Function from https://github.com/sjl/badwolf {{{
function! s:HL(group, fg, ...)
    " Arguments: group, guifg, guibg, gui, guisp

    let histring = 'hi ' . a:group . ' '

    if strlen(a:fg)
        if a:fg == 'fg'
            let histring .= 'guifg=fg ctermfg=fg '
        else
            let c = get(s:col, a:fg)
            let histring .= 'guifg=' . c[0] . ' ctermfg=' . c[1] . ' '
        endif
    endif

    if a:0 >= 1 && strlen(a:1)
        if a:1 == 'bg'
            let histring .= 'guibg=bg ctermbg=bg '
        else
            let c = get(s:col, a:1)
            let histring .= 'guibg=' . c[0] . ' ctermbg=' . c[1] . ' '
        endif
    endif

    if a:0 >= 2 && strlen(a:2)
        let histring .= 'gui=' . a:2 . ' cterm=' . a:2 . ' '
    endif

    if a:0 >= 3 && strlen(a:3)
        let c = get(s:col, a:3)
        let histring .= 'guisp=' . c[0] . ' '
    endif

    " echom histring

    execute histring
endfunction
" }}}
" Highlights {{{
call s:HL('Normal',          'foreground', 'darkbg')
call s:HL('NonText',         'comment',    'background')
call s:HL('WhiteSpace',      'comment',    'trailwhite')
call s:HL('EndOfBuffer',     'statusline', 'darker')
call s:HL('LineNr',          'comment',    'linenrbg')
call s:HL('FoldColumn',      'lighter_bg', 'darker')
call s:HL('Folded',          'fg_alt',    'statusline')
call s:HL('MatchParen',      'special',    'none',       'bold')
call s:HL('SignColumn',      'foreground', 'signbg')
call s:HL('Comment',         'fg_dark',    'none')
call s:HL('Conceal',         'error',      'none')
call s:HL('Constant',        'string',   'none')
call s:HL('Number',          'string',     'none')
call s:HL('Error',           'error',      'none',       'none')
call s:HL('Identifier',      'function',       'none')
call s:HL('Ignore',          'comment',    'none')
call s:HL('PreProc',         'preproc',    'none')
call s:HL('Special',         'special',    'none')
call s:HL('Statement',       'lemon',      'none',       'bold')
call s:HL('LightKeyword',    'lemon',      'none')
call s:HL('String',          'string',     'stringbg')
call s:HL('Todo',            'background', 'string')
call s:HL('Type',            'type',       'none',       'none')
call s:HL('Underlined',      'function',   'none')
call s:HL('Pmenu',           'foreground', 'pmenu')
call s:HL('PmenuSbar',       'light_bg',   'light_bg')
call s:HL('PmenuSel',        'background', 'lemon')
call s:HL('PmenuThumb',      'function')
call s:HL('ErrorMsg',        'error',      'none',       'none')
call s:HL('ModeMsg',         'special',    'none')
call s:HL('MoreMsg',         'function',   'none')
call s:HL('Question',        'foreground', 'none')
call s:HL('WarningMsg',      'lemon',      'none')
call s:HL('TabLine',         'foreground', 'light_bg',   'none')
call s:HL('TabLineFill',     'foreground', 'light_bg',   'none')
call s:HL('TabLineSel',      'foreground', 'statusline', 'bold')
call s:HL('Cursor',          'none',       'foreground')
call s:HL('CursorColumn',    'none',       'light_bg')
call s:HL('CursorLineNr',    'special',    'light_bg')
call s:HL('CursorLine',      'none',       'cline_bg',   'none')
call s:HL('StatusLine',      'statusline', 'foreground')
call s:HL('StatusLineNC',    'light_bg',   'comment')
call s:HL('MsgSeparator',    'none',       'msgsep')
call s:HL('Visual',          'none',       'selection')
call s:HL('VisualNOS',       'foreground', 'background')
call s:HL('VertSplit',       'lighter_bg', 'lighter_bg')
call s:HL('WildMenu',        'foreground', 'background')
call s:HL('Function',        'lightfun',   'none',       'none')
call s:HL('SpecialKey',      'special',    'none')
call s:HL('Title',           'lemon',      'none',       'bold')
call s:HL('DiffAdd',         'string',     'none')
call s:HL('DiffChange',      'lemon',      'none')
call s:HL('DiffDelete',      'error',      'none')
call s:HL('DiffText',        'function',   'none')
call s:HL('Directory',       'lemon',      'none')
call s:HL('debugPC',         'error',      'none')
call s:HL('debugBreakpoint', 'error',      'none')
call s:HL('ColorColumn',     'none',       'constant')
call s:HL('Delimiter',       'none',       'none')
call s:HL('Operator',        'none',       'none',       'none')
call s:HL('htmlTagName',     'lemon',      'none',       'bold')
call s:HL('htmlTag',         'foreground', 'none')
call s:HL('htmlArg',         'function',   'none')
call s:HL('@extern',         'sparkly',    'none',       'bold')
call s:HL('@attribute.c',    'darkbg',     'fg_alt',     'bold')
call s:HL('@property',       'lightfun',   'none',       'none')
call s:HL('@class',          'type',       'none',       'bold') " fooka amnitel


call s:HL('IncSearch',  'special', 'background', 'reverse,bold')
call s:HL('Search',     'special', 'background', 'reverse,bold')
call s:HL('Substitute', 'special', 'background', 'reverse,bold')
call s:HL('SpellBad',   'error',   'none',       'bold,underline')
call s:HL('SpellCap',   'error',   'none',       'bold,underline')
call s:HL('SpellLocal', 'special', 'none',       'bold,underline')
call s:HL('SpellRare',  'special', 'none',       'bold,underline')

call s:HL('GitSignsCurrentLineBlame',  'fg_dark', 'none',       'none')

" add to above
hi MsgSeparator blend=20
" fuuuuu
hi MsgArea blend=15 guibg=#281811

hi link Terminal                 Normal
hi link CursorIM                 Cursor
hi link Boolean                  Constant
hi link Character                Constant
hi link Conditional              Statement
hi link Debug                    Special
hi link Define                   PreProc
hi link Exception                Statement
hi link Float                    Number
hi link HelpCommand              Statement
hi link HelpExample              Statement
hi link Include                  PreProc
hi link Keyword                  Statement
hi link Label                    Statement
hi link Macro                    PreProc
hi link PreCondit                PreProc
hi link Repeat                   Statement
hi link SpecialChar              Special
hi link SpecialComment           Special
hi link StorageClass             Statement
hi link Structure                Statement
hi link Tag                      Special
hi link Terminal                 Normal
hi link Typedef                  Statement
hi link htmlEndTag               htmlTagName
hi link htmlLink                 Function
hi link htmlSpecialTagName       htmlTagName
hi link htmlTag                  htmlTagName
hi htmlBold                 gui=bold
hi htmlItalic               gui=italic
hi link xmlTag                   Statement
hi link xmlTagName               Statement
hi link xmlEndTag                Statement
hi link asciidocQuotedEmphasized Preproc
hi link diffBDiffer              WarningMsg
hi link diffCommon               WarningMsg
hi link diffDiffer               WarningMsg
hi link diffIdentical            WarningMsg
hi link diffIsA                  WarningMsg
hi link diffNoEOL                WarningMsg
hi link diffOnly                 WarningMsg
hi link diffRemoved              DiffDelete
hi link diffAdded                DiffAdd
hi link QuickFixLine             Search
hi link ConId                    Type

hi link @attribute Statement

hi link @lsp.type.variable NONE " too noisy
hi link @lsp.type.property @property
hi link @lsp.type.class.c @class " NOW YOU REALLY DONE IT

hi link @variable NONE " too noisy
hi link @repeat Statement
hi link @conditional Statement

hi link @type.definition.zig Type
hi link ZigDefinition LightKeyword
hi link @type.qualifier.zig ZigDefinition " bitch plz
hi link @attribute.zig ZigDefinition
hi link @keyword.function.zig ZigDefinition

" Yaml
hi link yamlBlockMappingKey Statement
hi link yamlFlowIndicator   SpecialKey

" Markdown
hi link markdownCode             String
hi link markdownCodeDelimiter    String
hi link markdownCodeBlock        String
hi link markdownHeadingDelimiter Type
hi link markdownLinkText         Special
hi link markdownItalic           Preproc

" CSS
hi link cssTagName    SpecialKey
hi link cssClassName  Statement
hi link cssDefinition Special
hi link cssProp       Special

" Fugitive
hi link fugitiveHash Constant

" C
hi link cSpecial Constant
hi link cSpecial Constant

" Python
hi link pythonBuiltin Constant

" 'MaxMEllon/vim-jsx-pretty'
hi link jsxComponentName Statement
hi link jsxTagName       Special

" Neomake
hi link NeomakeErrorSign ErrorMsg
hi link NeomakeWarningSign WarningMsg
hi link NeomakeMessageSign WarningMsg
hi link NeomakeInfoSign Type

hi link NeomakeVirtualtextError ErrorMsg
hi link NeomakeVirtualtextWarning WarningMsg
hi link NeomakeVirtualtextMessage WarningMsg
hi link NeomakeVirtualtextInfo Type

" lua

"zig
hi link @label.zig Function

"javascript :zany_face:
hi link JavaScriptFunction Statement
hi link JavaScriptNumber Number
"hi link @lsp.type.function.javascript NONE

" Fzf
if get(g:, 'sitruuna_fzf', 1) == 1
  let g:fzf_colors =
        \ { 'fg':    ['fg', 'NormalFloat'],
        \ 'bg':      ['bg', 'NormalFloat'],
        \ 'hl':      ['fg', 'Keyword', 'Keyword'],
        \ 'fg+':     ['fg', 'Function'],
        \ 'bg+':     ['bg', 'NormalFloat'],
        \ 'hl+':     ['fg', 'Keyword'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'border':  ['fg', 'Ignore'],
        \ 'prompt':  ['fg', 'DiffAdded'],
        \ 'pointer': ['fg', 'Function'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment'] }
endif

if has('nvim')
  let g:terminal_color_0 = s:col.background[0]
  let g:terminal_color_8 = s:col.lighter_bg[0]

  let g:terminal_color_1 = s:col.error[0]
  let g:terminal_color_9 = s:col.error[0]

  let g:terminal_color_2 = s:col.string[0]
  let g:terminal_color_10 = s:col.string[0]

  let g:terminal_color_3 = s:col.lemon[0]
  let g:terminal_color_11 = s:col.special[0]

  let g:terminal_color_4 = s:col.type[0]
  let g:terminal_color_12 = s:col.type[0]

  let g:terminal_color_5 = s:col.constant[0]
  let g:terminal_color_13 = s:col.preproc[0]

  let g:terminal_color_6 = s:col.function[0]
  let g:terminal_color_14 = s:col.function[0]

  let g:terminal_color_7 = s:col.comment[0]
  let g:terminal_color_15 = s:col.foreground[0]
endif
" }}}
