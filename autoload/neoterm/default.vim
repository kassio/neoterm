function! neoterm#default#opts(opts) abort
  let l:default_opts = {
        \ 'handlers': {},
        \ 'mod': '',
        \ 'args': '',
        \ 'buffer_id': 0,
        \ 'from_event': v:false,
        \ 'origin': neoterm#origin#new(),
        \ 'shell': g:neoterm_shell
        \ }
  return extend(copy(a:opts), l:default_opts, 'keep')
endfunction
