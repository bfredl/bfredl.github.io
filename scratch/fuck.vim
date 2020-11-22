noautocmd botright split __transient_state__
call setline(1, 'fuck')
call append(line('$'), '')

let br = bufnr('%')
let i = 2
let line = ''
for l in map(range(100), 'repeat(v:val, 10)')
    call append(line('$'), l . l)
    call nvim_buf_add_highlight(br, 0, 'String', i, 1, 2)
    call nvim_buf_add_highlight(br, 0, 'String', i, len(l) + 1, len(l) + 2)
    let i += 1
endfor
