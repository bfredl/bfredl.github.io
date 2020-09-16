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
" mappings: miniyank {{{
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
" LOGIC: preinit/lua {{{
if !get(g:, "bfredl_preinit")
  " TODO(neovim): nvim_get_runtime_file should allow you to find a directory
  " directly
  let &rtp = &rtp.','.fnamemodify(nvim_get_runtime_file("submod/packer.nvim/LICENSE", 0)[0], ':p:h')
  let g:bfredl_preinit = v:true
end

lua dofile(vim.api.nvim_get_runtime_file("lua/bfredl.lua", 0)[1])
" }}}
