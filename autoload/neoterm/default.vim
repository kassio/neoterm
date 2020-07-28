function! neoterm#default#opts(opts) abort
  return extend(copy(a:opts), g:neoterm.default_opts, 'keep')
endfunction
