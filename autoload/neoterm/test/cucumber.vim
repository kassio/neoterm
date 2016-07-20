function! neoterm#test#cucumber#run(scope)
  let path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')

  if exists('g:neoterm_cucumber_lib_cmd')
    let command = g:neoterm_cucumber_lib_cmd
  else
    let command = 'bundle exec cucumber'
  end

  if a:scope == 'file'
    let command .= ' ' . path
  elseif a:scope == 'current'
    let command .= ' ' . path . ':' . line('.')
  endif

  return command
endfunction
