function! neoterm#test#run(scope)
  let test_command = <sid>get_test_command(a:scope)
  let g:neoterm_last_test_command = g:neoterm_clear_cmd . ';' . test_command

  echo test_command
  silent call neoterm#exec([g:neoterm_last_test_command, ''])
endfunction

function! neoterm#test#rerun()
  if exists('g:neoterm_last_test_command')
    silent call neoterm#exec([g:neoterm_last_test_command, ''])
  else
    echo 'No test has been runned.'
  endif
endfunction

function! s:get_test_command(scope)
  if exists('b:neoterm_test_lib') && b:neoterm_test_lib != ''
    let Fn = function('neoterm#test#' . b:neoterm_test_lib . '#run')
  elseif exists('g:neoterm_test_lib') && g:neoterm_test_lib != ''
    let Fn = function('neoterm#test#' . g:neoterm_test_lib . '#run')
  else
    echo 'No test lib set.'
    return ''
  end

  return Fn(a:scope)
endfunction
