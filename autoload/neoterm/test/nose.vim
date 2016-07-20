function! neoterm#test#nose#run(scope)
  let path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')

  let command = 'nosetests'
  if a:scope == 'file'
    let command .= ' ' . path
  endif

  return command
endfunction
