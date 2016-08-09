function! neoterm#test#rake#run(scope)
  let path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')
  let command = 'rake test'
  let file_option = ' TEST="' . path . '"'

  if a:scope == 'all'
    return command
  elseif a:scope == 'file'
    return command . file_option
  elseif a:scope == 'current'
    return command . file_option . ' TESTOPTS="--name=\"/' . neoterm#test#minitest#get_current() . '/\""'
  endif
endfunction
