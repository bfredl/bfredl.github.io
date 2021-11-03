" just for looks {{{
set termguicolors
set winblend=20
set pumblend=15

set list
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:\ 
set fillchars=eob:█
set showbreak=↪

" }}}
" options: title {{{
" TODO(bfredl): make title a lua function, probably
let s:a = api_info().version
let g:_b_version = s:a.major.'.'.s:a.minor
" TODO(bfredl): show ASAN vs RelWithDebInfo
" when built from non-master branch, show branchname
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ NVIM\ %{g:_b_version}
" }}}
" TODO(bfredl): one logic please for detecting conflicting mappings
let g:mapleader = ","
" vimrc {{{
func bfredl#rt(name)
  return nvim_get_runtime_file(a:name, 0)[0]
endfunc
command Reload luafile $MYVIMRC

" TODO(bfredl): better mappings, works for now
noremap <leader>u <cmd>Reload<cr>
" TODO(bfredl): automagically on save in the lua files
noremap <leader>r <cmd>update<cr><cmd>Reload<cr>
" TODO(bfredl): jump to open window if already exist
noremap <Leader>v <cmd>exe "split ".bfredl#rt("autoload/bfredl.vim")<CR>
noremap <Leader>h <cmd>exe "split ".bfredl#rt("lua/bfredl/init.lua")<CR>
noremap <Leader>V <cmd>split ~/config/vimrc<CR>
augroup vimrc
  au!
  au BufWritePost $MYVIMRC Reload
  exe "au BufWritePost ".bfredl#rt("lua/bfredl/init.lua")." Reload"
  exe "au BufWritePost ".bfredl#rt("autoload/bfredl.vim")." Reload"
augroup END

command! IWrite au InsertLeave <buffer> nested write

noremap <silent> <Plug>ch:,l <cmd>update<cr><cmd>so %<cr>

" }}}
" path and files {{{
noremap <Plug>ch:ph :cd %:p:h<cr>
noremap <Plug>CH:ph :cd ..<cr>
" }}}
" windows {{{
noremap <Leader>o <C-W>o
noremap <Plug>ch:hc <C-W>w
noremap <Plug>CH:hc <C-W>W

noremap <Leader>s :sp<CR>:bn<CR>

noremap å :A<cr>
noremap Å :AS<cr>
" }}}
" save and exit {{{
nmap <Plug>ch:ir :w<cr>
nmap <Plug>CH:ir :w!<cr>
nmap ö :wq
nmap Ö :conf qa<cr>
" }}}
" clipboard and miniyank {{{
noremap <Plug>ch:,. "+y
nnoremap <Plug>CH:,. "+yy
noremap <Plug>ch:jk "*y
noremap <Plug>CH:jk "*yy
map <Leader>p "+p
map <Leader>P "+P
map <Leader>i "*p
map <Leader>I "*P

noremap <Plug>ch:it '[=']
noremap <Plug>CH:it '[V']
" ch:,u
noremap ü "*p'[V']>.

" TODO(bfredl): formally associate the mappings with the plugin
map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)
map <Leader>t <Plug>(miniyank-startput)
map <Leader>T <Plug>(miniyank-startPut)
map <Plug>ch:.p <Plug>(miniyank-cycle)
map <Plug>ch:ao <Plug>(miniyank-cycleback)
map <Leader>C <Plug>(miniyank-cycle)
map <Leader>b <Plug>(miniyank-toblock)
map <Leader>l <Plug>(miniyank-toline)
map <Leader>k <Plug>(miniyank-tochar)
" }}}
" motion and selection {{{
map <Plug>ch:jh <Plug>(easymotion-j)
map <Plug>ch:kh <Plug>(easymotion-k)
let g:EasyMotion_keys = "aoeidtn',.pgljkbmuh:cr"

map <Space> <plug>Sneak_s
nmap S <plug>Sneak_S
noremap s s

map <Plug>ch:pr vap

function! TheWalk()
    let start = virtcol(".")
    call cursor([line(".")-1, 0])
    " thanks to @jamessan
    call search('\%(\k\@<!\|\s\@<=\)\k\|\%(\k\|\s\)\@<=\%(\k\|\s\)\@!')
    let end = virtcol(".")
    return repeat(" ",end-start)
endfunc
inoremap <expr> <Plug>ch:es TheWalk()

map <Plug>ch:jc :cnext<cr>
map <Plug>ch:kc :cprev<cr>
map <Plug>ch:jn :lnext<cr>
map <Plug>ch:kn :lprev<cr>


map <Plug>ch:en <Plug>(argclinic-deletearg)
map <Plug>ch:pn <Plug>(argclinic-putarg)
map <Plug>ch:pt <Plug>(argclinic-putarg-before)

map <Plug>ch:an <Plug>(argclinic-nextarg)
map <Plug>ch:av <Plug>(argclinic-nextend)
map <Plug>ch:at <Plug>(argclinic-prevarg)
map <Plug>ch:aw <Plug>(argclinic-prevend)

omap ie <Plug>(argclinic-selectarg)
xmap ie <Plug>(argclinic-selectarg)

noremap <Plug>ch:jt gj
noremap <Plug>ch:kt gk
noremap <Plug>ch:hn :noh<cr>

noremap <expr> <Plug>ch:hv ":setlocal colorcolumn=".(&cc==80?0:80)."<cr>"

function! bfredl#tagInSplit(tag)
  if &ft=="help"
    split
  else
    wincmd w
  end
  exec "tag ".a:tag
endfunction
nnoremap <Plug>ch:ou <c-]>
nnoremap <Plug>CH:ou :call bfredl#tagInSplit(expand("<cword>"))<cr>


" }}}
" is of no SPEL {{{
noremap <Plug>ch:js ]s
noremap <Plug>ch:ks [s
" fix spel
noremap <Plug>ch:es z=
" }}}
" grepping and searching{{{
noremap <Plug>ch:ag :Ack!<space>
noremap <Plug>CH:ag *:AckFromSearch!<cr>

" STFU
noremap <Plug>ch:hn :noh<cr>

if executable("rg")
  let g:ackprg = 'rg --vimgrep --no-heading'
elseif executable("ag")
  let g:ackprg = 'ag --vimgrep'
endif
" }}}
" telescope {{{
nnoremap <Plug>ch:.u <cmd>Telescope buffers<cr>
nnoremap <Plug>ch:ig <cmd>Telescope live_grep<cr>
nnoremap <Plug>ch:am :Telescope <c-z>
" }}}
" LSP {{{
function! bfredl#lspmap()
" shiiny
set winblend=20
nmap <buffer> <Plug>ch:,d <cmd>lua vim.lsp.buf.signature_help()<cr>
nmap <buffer> <Plug>ch:id <cmd>lua vim.lsp.buf.definition()<cr>
nmap <buffer> <Plug>CH:id <cmd>lua vim.lsp.buf.declaration()<cr>
nmap <buffer> K <cmd>lua vim.lsp.buf.hover()<cr>
nmap <buffer> <Plug>ch:mv <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>
setl omnifunc=v:lua.vim.lsp.omnifunc
" ic does not work, delete ic->char ?
"map <buffer> <Plug>ch:ic <cmd>lua vim.lsp.buf_request(nil, 'textDocument/completion', vim.lsp.protocol.make_text_document_position_params())<cr>
endfunction
command! ASAN set efm=%*[^/]%f:%l:%c | cfile /tmp/theasanfile
" }}}
" fugutive and gitgutter {{{
command! Gc Gcommit -va
command! Gcm Gcommit -v
command! Gw Gwrite
command! Gr Gread
command! -nargs=* Gd Gdiff <args>
command! Gdp Gdiff HEAD^
command! Gb Git blame

let g:gitgutter_map_keys = 0 " no u
map <Plug>ch:tn :GitGutterNextHunk<cr>
map <Plug>CH:tn :GitGutterPrevHunk<cr>

" intentional no<cr>
map <Plug>CH:tr :GitGutterRevertHunk
map <Plug>ch:ts :GitGutterStageHunk

" diffput/diffget
noremap <Plug>ch:pd dp
noremap <Plug>ch:od do

augroup diffy
  au BufWritePre,InsertLeave * GitGutter
augroup END

" }}}
" a brief interchange {{{
nmap cr cx
nmap crr cxx
" [I]nterchange single [c]haracter
nmap <Plug>ch:ic cxl
nmap <Plug>CH:ic cxf
vmap <Plug>ch:ic X
nmap <Plug>ch:iw criw
nmap <Plug>CH:iw criW
" }}}
" nlua / luadev {{{
func! bfredl#nlua()
	nmap <buffer> <Plug>ch:un <Plug>(Luadev-RunLine)
	nmap <buffer> <Plug>ch:ud <Plug>(Luadev-RunWord)
	vmap <buffer> <Plug>ch:un <Plug>(Luadev-Run)
	imap <buffer> <Plug>ch:.u <Plug>(Luadev-Complete)
endfunc

func! bfredl#luadevlaunch(...)
  Luadev
  call bfredl#nlua()
endfunc
command! NL :call bfredl#luadevlaunch()

" }}}
" nvim-ipy {{{
let g:nvim_ipy_perform_mappings = 0
let g:ipy_shortprompt = 1
let g:ipy_truncate_input = 3

function! bfredl#get_current_word()
    let isk_save = &isk
    let &isk = '@,48-57,_,192-255,.'
    let word = expand("<cword>")
    let &isk = isk_save
    return word
endfunction


func! bfredl#ipy()
  map <Plug>ch:un <Plug>(IPy-Run)
  imap <Plug>ch:un <c-o><Plug>(IPy-Run)
  nmap <Plug>ch:ur <Plug>(IPy-RunCell)
  map <Plug>ch:mw <Plug>(IPy-RunOp)

  nnoremap <Plug>ch:uc :w<cr>:<c-u>call IPyRun('%run -i '.bfredl#runfile())<cr>
  " TODO: test if python or not
  nmap <Plug>CH:uc :let b:the_run_file = "
  "nmap <Plug>ch:ai :w<cr>:<c-u>call IPyRun('%aimport *'.bufname('%')[:-4])<cr>

  imap <Plug>ch:ic <Plug>(IPy-Complete)
  imap <Plug>CH:un <c-o><Plug>(IPy-Run)<cr>
  map <Plug>ch:rl :let g:ip_reload = '
  map <Plug>ch:hr :<c-u>call IPyRun(ip_reload)<cr><Plug>(IPy-Run)
  map <Plug>CH:hr :<c-u>call IPyRun(ip_reload)<cr>
  map <Plug>ch:in :w<cr>:<c-u>call IPyRun(ip_reload)<cr>

  map <Plug>CH:qu <Plug>(IPy-Interrupt)
  map <Plug>CH:qk <Plug>(IPy-Terminate)
  map <Plug>ch:id <Plug>(IPy-WordObjInfo)
  set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)%(\ -\ %{g:ipy_status}%)\ -\ NVIM
  map <Plug>ch:id <Plug>(IPy-WordObjInfo)
  noremap <Plug>ch:um <Cmd>call IPyRun(bfredl#get_current_word().'.shape')<cr>
  nnoremap <bs> <Cmd>call IPyRun('type('.bfredl#get_current_word().')')<cr>

  " TODO: Justice de Julia
  nnoremap <Plug>ch:ig :call IPyRun('figure();',1)<cr>
  nnoremap <Plug>CH:pc :call IPyRun('close("all");',1)<cr>
  nnoremap <Plug>ch:el :call IPyRun('clf();',1)<cr>
  nnoremap <Plug>ch:pm :call IPyRun("%matplotlib tk")<cr>
  nnoremap <Plug>CH:pm :call IPyRun("%matplotlib tk\nfrom matplotlib.pyplot import *")<cr>
  let g:hasipy = 1 " TODO: can into minor mode?
endfunc
if exists('g:hasipy')
  " for reloads
  call bfredl#ipy()
endif

function! bfredl#runfile()
    return get(b:, "the_run_file", bufname('%'))
endfunction

func! bfredl#ipylaunch(...)
  call call("IPyConnect", a:000)
  call bfredl#ipy()
endfunc
command! -nargs=* IP :call bfredl#ipylaunch(<f-args>)
command! -nargs=* IJ :call bfredl#ipylaunch("--kernel", "julia-1.6")
command! -nargs=* IR :call bfredl#ipylaunch("--kernel", "ir")
" }}}
" insert mode: completion {{{
set completeopt=menuone,preview,longest

func! bfredl#unblank()
  let ch = matchstr(getline('.'), '\%' . (col('.')-1) . 'c.')
  return ch != "" && ch != " " && ch != "\t"
endfunc
func! bfredl#tabfunc()
  return (bfredl#unblank() || pumvisible())
endfunc

imap <expr> <tab> bfredl#tabfunc()  ? "<c-n>" : "<tab>"

" TODO: this bugs up copilot.vim
"imap <expr> <tab> (bfredl#unblank() \|\| pumvisible()) ? "<c-n>" : "<tab>"

" [p]ath [c]ompletion
inoremap <Plug>ch:pc <c-x><c-f>
" OMNI
inoremap <Plug>ch:.u <c-x><c-o>
" }}}
" cmdline and wildmenu {{{
set wildmenu
set wildmode=longest:full,full
set wildignorecase
" NO WILDCHARM
set wc=0 wcm=0
cnoremap <tab> <c-z>
func! bfredl#spacey()
  return getcmdline()[-1:] == "/" ? "\<bs>" : ""
endfunc
cnoremap <expr> / wildmenumode() ? bfredl#spacey()."/<c-z>" : "/"


cnoremap <c-t> <c-f>
cnoremap <c-h> <c-f>0
" }}}
" filetype {{{
filetype plugin indent on
set shortmess-=F
augroup Filetypes
  au!
  au FileType python call bfredl#python()
  au FileType rmd let b:ipy_celldef = ['^```{r\( \a*\)\?}$', '^```$']
  au FileType rmd set isk+=_
  au FileType markdown let b:ipy_celldef = ['\v^```\a*$', '^```$']
  au FileType matlab let b:ipy_celldef = '^%%'
  au FileType c,zig call bfredl#lspmap()
  au FileType c call bfredl#nvim_c_ft()
  au FileType vim call bfredl#vim_ft()
  "exe "au BufReadPost ".bfredl#rt("lua/bfredl/miniline.lua")." match Grupp /^\[\[.\+]]/"
  "au FileType lua 1match Grupp /^\[\[.\+]]/
  "au FileType lua 2match Option /^\s*'[a-z]\+'/
augroup END

func! bfredl#python() "{{{
  "imap <buffer> <Plug>CH:kd dm<c-e>
  "imap <buffer> <Plug>CH:ic ci<c-e>

  "call SemshiHighlight()

"map <buffer>  <Plug>ch:jt :<c-u>let g:jedi#show_call_signatures=1-g:jedi#show_call_signatures<cr>
endfunc

" }}}
" semshi {{{
let g:semshi#simplify_markup = v:false
let g:semshi#excluded_hl_groups = ['self', 'local']
let g:semshi#mark_selected_nodes = 2
" }}}
" julia {{{
let g:latex_to_unicode_tab = 0
" }}}
"
func bfredl#nvim_c_ft()
  setlocal expandtab
  setlocal shiftwidth=2
  setlocal softtabstop=2
  setlocal textwidth=80
  setlocal comments=:///,://
  setlocal cinoptions=0(
  setlocal commentstring=//\ %s
endfunc

function! bfredl#vim_ft() "{{{
    noremap <silent> <buffer> <Plug>ch:un <cmd>execute getline('.')<cr>
endfunction
" }}}

func bfredl#nvimdev()
  augroup nvimdev
    au!
    au BufRead,BufNewFile *.h set filetype=c
    au FileType c call bfredl#nvim_c_ft()
  augroup END

  if &ft ==# 'c'
    call bfredl#nvim_c_ft()
  endif
endfunc

let g:tex_flavor = 'latex'
" }}}
" get_selection {{{
" thanks to @xolox on stackoverflow for visual selection
" and to @mightymicha for operator selection
function! bfredl#get_selection(is_op)
    let [lnum1, col1] = getpos(a:is_op ? "'[" : "'<")[1:2]
    let [lnum2, col2] = getpos(a:is_op ? "']" : "'>")[1:2]

    if lnum1 > lnum2
      let [lnum1, col1, lnum2, col2] = [lnum2, col2, lnum1, col1]
    endif

    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - ((&selection == 'inclusive' || a:is_op) ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]

    " TODO: GRUGG 'operatorfunc' GRUGG! "line" "char" "block" GRUG GRUGG!
    return join(lines, "\n").((visualmode() ==# "V") ? "\n" : "")
endfunction

" }}}
"map <Plug>ch:ht V"ep
