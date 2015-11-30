function! neoterm#test#npm#run(scope)
  if exists('g:neoterm_npm_lib_cmd')
    let command = g:neoterm_npm_lib_cmd
  else
    let command = 'npm test'
  end

  if a:scope == 'file'
    let command .= ' ' . expand('%:p')
  endif

  return command
endfunction
