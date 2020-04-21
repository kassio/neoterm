function! neoterm#origin#new() abort
  return {
        \ 'win_id': exists('*win_getid') ? win_getid() : 0,
        \ 'last_buffer_id': bufnr('#')
        \ }
endfunction

function! neoterm#origin#return(origin, ...) abort
  if get(a:, 1, '') ==# 'buffer'
    exec printf('buffer %s', a:origin.last_buffer_id)
  elseif a:origin.win_id
    call win_gotoid(a:origin.win_id)
  else
    wincmd p
  end
endfunction
