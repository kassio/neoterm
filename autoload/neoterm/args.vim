function! neoterm#args#size(args, default) abort
  let l:size = str2nr(matchstr(a:args, 'resize=\zs\d\+'))
  let l:size = l:size > 0 ? l:size : a:default

  return str2nr(l:size) == 0 ? '' : l:size
endfunction
