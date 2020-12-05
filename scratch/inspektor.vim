let s:thebuf = nvim_create_buf(1,1)
exe "autocmd TextChanged,TextChangedI <buffer> call nvim_buf_set_lines(".s:thebuf.", 0, -1, 1, [nvim__buf_debug_extmarks(0, 1)])"
let s:sav = nvim_get_current_win()
split
call nvim_win_set_buf(0,s:thebuf)
call nvim_set_current_win(s:sav)
