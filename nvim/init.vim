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
" color scheme {{{
set termguicolors
set winblend=20
set pumblend=15
" #223341
" }}}
" options: title {{{
" TODO(bfredl): make title a lua function, probably
let s:a = api_info().version
let g:_b_version = s:a.major.'.'.s:a.minor
" TODO(bfredl): show ASAN vs RelWithDebInfo
" when built from non-master branch, show branchname
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ NVIM\ (newconf,\ %{g:_b_version})
" }}}
" TODO(bfredl): one logic please for detecting conflicting mappings

let g:mapleader = ","
" mappings: vimrc {{{
" TODO(bfredl): better mappings, works for now
noremap <leader>u <cmd>source $MYVIMRC<cr>
" TODO(bfredl): automagically on save in the lua files
noremap <leader>r <cmd>update<cr><cmd>source $MYVIMRC<cr>
" TODO(bfredl): jump to open window if already exist
noremap <Leader>v <cmd>split $MYVIMRC<CR>
noremap <Leader>h <cmd>exe "split ".nvim_get_runtime_file("lua/bfredl.lua", 0)[0]<CR>
augroup vimrc
  au!
  au BufWritePost $MYVIMRC source $MYVIMRC
  exe "au BufWritePost ".nvim_get_runtime_file("lua/bfredl.lua", 0)[0]." source $MYVIMRC"
augroup END
command! IS au InsertLeave <buffer> nested write
" }}}
" mappings: windows {{{
noremap <Leader>o <C-W>o
noremap <Plug>ch:hc <C-W>w
noremap <Plug>CH:hc <C-W>W
" }}}
" mappings: save and exit {{{
nmap <Plug>ch:ir :w<cr>
nmap <Plug>CH:ir :w!<cr>
nmap ö :wq
nmap Ö :conf qa<cr>
" }}}
" mappings: clipboard and miniyank {{{
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
" mappings: NL {{{
function! NLuaBindings()
	nmap <buffer> <Plug>ch:un <Plug>(Luadev-RunLine)
	nmap <buffer> <Plug>ch:ud <Plug>(Luadev-RunWord)
	vmap <buffer> <Plug>ch:un <Plug>(Luadev-Run)
	imap <buffer> <Plug>ch:.u <Plug>(Luadev-Complete)
endfunction
" }}}
function! LuadevLaunch(...) "{{{
    Luadev
    call NLuaBindings()
endfunction
command! NL :call LuadevLaunch()

" }}}
" mappings: SUPERTAB {{{
function! UnBlank()
  let ch = matchstr(getline('.'), '\%' . (col('.')-1) . 'c.')
  return ch != "" && ch != " " && ch != "\t"
endfunction
imap <expr> <tab> (UnBlank() \|\| pumvisible()) ? "<c-n>" : "<tab>"
" }}}
" LOGIC: preinit/lua {{{
if !get(g:, "bfredl_preinit")
  " TODO(neovim): nvim_get_runtime_file should allow you to find a directory directly
  let g:bfredl_preinit = v:true
end

lua dofile(vim.api.nvim_get_runtime_file("lua/bfredl.lua", 0)[1])
" }}}
