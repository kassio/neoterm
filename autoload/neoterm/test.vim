function! neoterm#test#run(scope)
  let Fn = function('neoterm#test#' . g:neoterm_test_lib)
  let g:neoterm_last_test_command = g:neoterm_clear_cmd . ';' . Fn(a:scope)

  call neoterm#exec([g:neoterm_last_test_command, ''])
endfunction

function! neoterm#test#rerun()
  if exists('g:neoterm_last_test_command')
    call neoterm#exec([g:neoterm_last_test_command, ''])
  else
    echo 'No test has been runned.'
  endif
endfunction

function! neoterm#test#rspec(scope)
  let command = 'rspec'

  if a:scope == 'file'
    let command .= ' ' . expand('%:p')
  elseif a:scope == 'current'
    let command .= ' ' . expand('%:p') . ':' . line('.')
  endif

  return command
endfunction

function! neoterm#test#minitest(scope)
  if a:scope == 'all'
    let command = 'rake test'
  elseif a:scope == 'file'
    let command = 'ruby -Ilib:test ' . expand('%:p')
  elseif a:scope == 'current'
    let command = 'ruby -Ilib:test ' . expand('%:p') . ' -n /' . <sid>minitest_get_current() . '/'
  endif

  return command
endfunction

function! s:minitest_get_current()
  let nearest_test = search("def\ test_", "nb")

  if nearest_test != 0
    return matchstr(getline(nearest_test), "test_.*")
  else
    let nearest_test = search("\\(test\\|it\\)\\s", 'nb')

    if nearest_test
      let test_string = split(getline(nearest_test), '["'']')[1]
      let test_string = escape(test_string, '#')

      return substitute(tolower(test_string), ' ', '_', 'g')
    endif
  endif
endfunction
