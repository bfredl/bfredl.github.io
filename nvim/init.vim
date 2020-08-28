set hidden
set title
set number

" TODO(bfredl): make title a lua function, probably
let s:a = api_info().version
let g:_b_version = s:a.major.'.'.s:a.minor
" TODO(bfredl): show ASAN vs RelWithDebInfo
" when built from non-master branch, show branchname
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ NVIM\ (newconf,\ %{g:_b_version})

let g:mapleader = ","
" TODO(bfredl): better mappings, works for now
map <leader>l <cmd>source $MYVIMRC<cr>

if !get(g:, "bfredl_preinit")
  " TODO(neovim): nvim_get_runtime_file should allow you to find a directory
  " directly
  let &rtp = &rtp.','.fnamemodify(nvim_get_runtime_file("submod/packer.nvim/LICENSE", 0)[0], ':p:h')
  let g:bfredl_preinit = v:true
end

lua dofile(vim.api.nvim_get_runtime_file("lua/bfredl_init.lua", 0)[1])
