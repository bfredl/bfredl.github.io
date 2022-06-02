so datadump.vim

let vals = g:dattan._VAL
echo len(vals)
let seversion = vals[0][1]
echo seversion
call setreg("+", string(seversion))
for i in range(len(vals))
  " echomsg vals[i]
endfor
