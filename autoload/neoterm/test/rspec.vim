function! neoterm#test#rspec#run(scope)
  if exists('g:neoterm_rspec_lib_cmd')
    let command = g:neoterm_rspec_lib_cmd
  else
    let command = 'bundle exec rspec'
  end

  if a:scope == 'file'
    let command .= ' ' . expand('%:p')
  elseif a:scope == 'current'
    let command .= ' ' . expand('%:p') . ':' . line('.')
  endif

  return command
endfunction
