function! neoterm#origin#new()
  return {
        \ 'win_id': exists('*win_getid') ? win_getid() : 0,
        \ 'buffer_id': bufnr('#')
        \ }
endfunction

function! neoterm#origin#return(origin, ...)
  if get(a:, 1, '') ==# 'buffer'
    exec printf('buffer %s', a:origin.buffer_id)
  elseif a:origin.win_id
    call win_gotoid(a:origin.win_id)
  else
    wincmd p
  end
endfunction
