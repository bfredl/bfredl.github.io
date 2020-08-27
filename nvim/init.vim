set hidden
set title
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ NVIM\ (newconf)

if !get(g:, "bfredl_preinit")
  " TODO(upstream): nvim_get_runtime_file should allow you to find a directory
  " directly
  let &rtp = &rtp.','.fnamemodify(nvim_get_runtime_file("submod/packer.nvim/LICENSE", 0)[0], ':p:h')
  let g:bfredl_preinit = v:true
end

lua dofile(vim.api.nvim_get_runtime_file("lua/bfredl_init.lua", 0)[1])
