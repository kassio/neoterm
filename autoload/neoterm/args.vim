function! neoterm#args#size(args, default) abort
  let l:size = matchstr(a:args, 'resize=\zs\d\+')
  let l:size = empty(l:size) ? a:default : l:size

  return str2nr(l:size)
endfunction
