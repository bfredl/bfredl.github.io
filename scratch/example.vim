let buf = nvim_create_buf(v:false, v:true)
let popup = nvim_open_win(buf, 0, {
      \   'relative':  'editor',
      \   'row':       15,
      \   'col':       5,
      \   'width':     20,
      \   'height':    5,
      \   'focusable': v:false,
      \   'style':     'minimal',
      \   'border':    'single',
      \ })
call setwinvar(popup, '&winhighlight', 'Normal:Normal')
