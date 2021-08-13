
let g:raa = keys(v:)
let g:paa = values(v:)
let g:i = 0

for s:zz in values(v:) 
  if g:raa[g:i] == "lua"
    let g:box = g:paa[(g:i):(g:i)]
    let g:Box = g:paa[(g:i)]
  else
  endif
  let g:i = g:i + 1
endfor

let g:Unbox = g:box[0]

function! TinkFunk(boo)
  echo a:boo
endfunction
function! ZorgFunk(boo)
  echo a:boo.require'vim.inspect'()
endfunction
function! HungFunk(boo)
  let l:gloo = a:boo[0]
  echo gloo
  echo gloo.require'vim.inspect'()
endfunction

