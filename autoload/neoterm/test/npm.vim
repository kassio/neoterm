function! neoterm#test#npm#run(scope)
  let path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')

  if exists('g:neoterm_npm_lib_cmd')
    let command = g:neoterm_npm_lib_cmd
  else
    let command = 'npm test'
  end

  if a:scope == 'file'
    let command .= ' ' . path
  endif

  return command
endfunction
