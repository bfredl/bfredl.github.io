" options: basic {{{
set hidden
set title
set number
set smartcase
set ignorecase
set expandtab
set sw=2 ts=2 sts=2
set incsearch
set mouse=a
set updatetime=1666
set foldmethod=marker
set nomodeline
set cpo-=_
if has("vim_starting")
    " I liked this better:
    let &dir = ".,".&dir
endif

set splitbelow

" }}}
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
" TODO(bfredl): better mappings, works for now
noremap <leader>u <cmd>luaf $MYVIMRC<cr>
" TODO(bfredl): automagically on save in the lua files
noremap <leader>r <cmd>update<cr><cmd>luafile $MYVIMRC<cr>
" TODO(bfredl): jump to open window if already exist
noremap <Leader>v <cmd>exe "split ".nvim_get_runtime_file("autoload/bfredl.vim", 0)[0]<CR>
noremap <Leader>h <cmd>exe "split ".nvim_get_runtime_file("lua/bfredl.lua", 0)[0]<CR>
augroup vimrc
  au!
  au BufWritePost $MYVIMRC luaf $MYVIMRC
  exe "au BufWritePost ".nvim_get_runtime_file("lua/bfredl.lua", 0)[0]." luaf $MYVIMRC"
augroup END

command! IWrite au InsertLeave <buffer> nested write

noremap <silent> <Plug>ch:,l :up<CR>:so %<CR>
au FileType lua noremap <buffer> <silent> <Plug>ch:,l :up<CR>:luafile %<CR>

" }}}
" windows {{{
noremap <Leader>o <C-W>o
noremap <Plug>ch:hc <C-W>w
noremap <Plug>CH:hc <C-W>W
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
" }}}
" grepping and searching{{{
noremap <Plug>ch:ag :Ack!<space>
noremap <Plug>CH:ag *:AckFromSearch!<cr>

if executable("rg")
  let g:ackprg = 'rg --vimgrep --no-heading'
elseif executable("ag")
  let g:ackprg = 'ag --vimgrep'
endif
" }}}
" telescope {{{
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <Plug>ch:.u <cmd>Telescope buffers<cr>
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
  noremap <Plug>ch:um <Cmd>call IPyRun(Get_current_word().'.shape')<cr>
  nnoremap <bs> <Cmd>call IPyRun('type('.Get_current_word().')')<cr>

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
command! -nargs=* IJ :call bfredl#ipylaunch("--kernel", "julia-1.0")
command! -nargs=* IR :call bfredl#ipylaunch("--kernel", "ir")
" }}}
" insert mode: SUPERTAB {{{
func! bfredl#unblank()
  let ch = matchstr(getline('.'), '\%' . (col('.')-1) . 'c.')
  return ch != "" && ch != " " && ch != "\t"
endfunc
imap <expr> <tab> (bfredl#unblank() \|\| pumvisible()) ? "<c-n>" : "<tab>"
" }}}
" cmdline: wildmenu {{{
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
" }}}
" filetype {{{
augroup Filetypes
  au!
  au FileType python call bfredl#python()
  au FileType rmd let b:ipy_celldef = ['^```{r\( \a*\)\?}$', '^```$']
  au FileType rmd set isk+=_
  au FileType markdown let b:ipy_celldef = ['\v^```\a*$', '^```$']
  au FileType matlab let b:ipy_celldef = '^%%'
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
