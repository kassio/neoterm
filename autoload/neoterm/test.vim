function! neoterm#test#run(scope)
  if exists('g:neoterm_test_lib') && g:neoterm_test_lib != ''
    let Fn = function('neoterm#test#' . g:neoterm_test_lib . '#run')
    let g:neoterm_last_test_command = g:neoterm_clear_cmd . ';' . Fn(a:scope)

    call neoterm#exec([g:neoterm_last_test_command, ''])
  else
    echo 'No test lib set.'
  end
endfunction

function! neoterm#test#rerun()
  if exists('g:neoterm_last_test_command')
    call neoterm#exec([g:neoterm_last_test_command, ''])
  else
    echo 'No test has been runned.'
  endif
endfunction
