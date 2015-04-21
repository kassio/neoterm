function! neoterm#test#cucumber#run(scope)
  if exists('g:neoterm_cucumber_lib_cmd')
    let command = g:neoterm_cucumber_lib_cmd
  else
    let command = 'bundle exec cucumber'
  end

  if a:scope == 'file'
    let command .= ' ' . expand('%:p')
  elseif a:scope == 'current'
    let command .= ' ' . expand('%:p') . ':' . line('.')
  endif

  return command
endfunction
