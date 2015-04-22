function! neoterm#test#nose#run(scope)
  let command = 'nosetests'
  if a:scope == 'file'
    let command .= ' ' . expand('%:p')
  endif

  return command
endfunction
