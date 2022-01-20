function! neoterm#default#opts(opts) abort
  let l:default_opts = {
        \ 'handlers': {},
        \ 'mod': '',
        \ 'buffer_id': 0,
        \ 'from_session': v:false,
        \ 'origin': neoterm#origin#new(),
        \ 'size': g:neoterm_size,
        \ 'shell': g:neoterm_shell
        \ }
  return extend(copy(a:opts), l:default_opts, 'keep')
endfunction
