function! neoterm#test#rspec#run(scope)
  let command = 'rspec'

  if a:scope == 'file'
    let command .= ' ' . expand('%:p')
  elseif a:scope == 'current'
    let command .= ' ' . expand('%:p') . ':' . line('.')
  endif

  return command
endfunction
