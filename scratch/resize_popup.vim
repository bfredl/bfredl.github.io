scriptencoding utf-8

let s:popup_win_id = 0
let s:nvim_border_win_id = 0
let s:popup_buffer = 0
"
" tooltip dimensions
let s:min_width = 1
let s:min_height = 1
let s:max_width = 80
let s:max_height = 20


function ClosePopup()
  call nvim_win_close( s:popup_win_id, v:true )
  call nvim_win_close( s:nvim_border_win_id, v:true )
endfunction

function CreatePopup()
  call s:Open( [ 'a', 'b', 'c' ] )
endfunction

function SetPopupText( body )
  call nvim_buf_set_option( s:popup_buffer, 'modifiable', v:true )
  call nvim_buf_set_lines( s:popup_buffer, 0, -1, v:true, a:body )
  call nvim_buf_set_option( s:popup_buffer, 'modifiable', v:false )
  call nvim_buf_set_option( s:popup_buffer, 'modified', v:false )
endfunction

function GrowPopup()
  call SetPopupText( [
        \ 'long',
        \ 'longer',
        \ 'longest'
        \ ] )

  call s:Resize()
endfunction

function ShrinkPopup()
  call SetPopupText( [
        \ 'l',
        \ 'l',
        \ 'l'
        \ ] )

  call s:Resize()
endfunction

function! s:GenerateBorder( width, height ) abort
  let top = '╭' . repeat('─',a:width + 2) . '╮'
  let mid = '│' . repeat(' ',a:width + 2) . '│'
  let bot = '╰' . repeat('─',a:width + 2) . '╯'
  let lines = [ top ] + repeat( [ mid ], a:height ) + [ bot ]

  return lines
endfunction

function s:Open( body )
  let buf_id = nvim_create_buf( v:false, v:true )
  call nvim_buf_set_lines( buf_id,
                         \ 0,
                         \ -1,
                         \ v:true,
                         \ s:GenerateBorder( s:max_width, s:max_height ) )
  " default the dimensions initially, then we'll calculate the real size and
  " resize it.
  let opts = {
        \ 'relative': 'cursor',
        \ 'width': s:max_width + 2,
        \ 'height': s:max_height + 2,
        \ 'col': 0,
        \ 'row': 1,
        \ 'anchor': 'NW',
        \ 'style': 'minimal'
        \ }

  " this is the border window
  let s:nvim_border_win_id = nvim_open_win( buf_id, 0, opts )
  call nvim_win_set_option( s:nvim_border_win_id, 'signcolumn', 'no' )
  call nvim_win_set_option( s:nvim_border_win_id, 'relativenumber', v:false )
  call nvim_win_set_option( s:nvim_border_win_id, 'number', v:false )

  " when calculating where to display the content window, we need to account
  " for the border
  let opts.row += 1
  let opts.height -= 2
  let opts.col += 2
  let opts.width -= 4

  " create the content window
  let s:popup_buffer = nvim_create_buf( v:false, v:true )
  call nvim_buf_set_lines( s:popup_buffer, 0, -1, v:true, a:body )
  call nvim_buf_set_option( s:popup_buffer, 'modifiable', v:false )
  let s:popup_win_id = nvim_open_win( s:popup_buffer, v:false, opts )

  " Apparently none of these work
  call nvim_win_set_option( s:popup_win_id, 'wrap', v:false )
  call nvim_win_set_option( s:popup_win_id, 'cursorline', v:true )
  call nvim_win_set_option( s:popup_win_id, 'signcolumn', 'no' )
  call nvim_win_set_option( s:popup_win_id, 'relativenumber', v:false )
  call nvim_win_set_option( s:popup_win_id, 'number', v:false )

  " Move the cursor into the popup window, as this is the only way we can
  " interract with the popup in neovim
  noautocmd call win_gotoid( s:popup_win_id )

  nnoremap <silent> <buffer> <nowait> g <cmd>call GrowPopup()<CR>
  nnoremap <silent> <buffer> <nowait> s <cmd>call ShrinkPopup()<CR>

  " Close the popup whenever we leave this window
  augroup ClosePopup
    autocmd!
    autocmd WinLeave <buffer>
          \ :call ClosePopup()
          \ | autocmd! ClosePopup
  augroup END

  call s:Resize()
endfunction

function s:Resize()
  if s:popup_win_id <= 0 || s:nvim_border_win_id <= 0
    " nothing to resize
    return
  endif

  noautocmd call win_gotoid( s:popup_win_id )
  let buf_lines = getline( 1, '$' )

  let width = s:min_width
  let height = min( [ max( [ s:min_height, len( buf_lines ) ] ),
                  \   s:max_height ] )

  " calculate the longest line
  for l in buf_lines
    let width = max( [ width, len( l ) ] )
  endfor

  let width = min( [ width, s:max_width ] )

  let opts = {
        \ 'width': width,
        \ 'height': height,
        \ }

  " resize the content window
  call nvim_win_set_config( s:popup_win_id, opts )

  " resize the border window
  let opts[ 'width' ] = width + 4
  let opts[ 'height' ] = height + 2

  call nvim_win_set_config( s:nvim_border_win_id, opts )
  call nvim_buf_set_lines( nvim_win_get_buf( s:nvim_border_win_id ),
                         \ 0,
                         \ -1,
                         \ v:true,
                         \ s:GenerateBorder( width, height ) )
endfunction


call CreatePopup()
