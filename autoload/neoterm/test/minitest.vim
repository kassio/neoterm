function! neoterm#test#minitest#run(scope)
  let path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')

  if a:scope == 'all'
    let command = 'rake test'
  elseif a:scope == 'file'
    let command = 'ruby -Ilib:test ' . path
  elseif a:scope == 'current'
    let command = 'ruby -Ilib:test ' . path . ' -n /' . s:format_test_name(neoterm#test#minitest#get_current()) . '/'
  endif

  return command
endfunction

function! neoterm#test#minitest#get_current()
  let nearest_test = search("def\ test_", "nb")

  if nearest_test != 0
    return matchstr(getline(nearest_test), "test_.*")
  else
    let nearest_test = search("^\\s*\\(test\\|it\\)\\s", 'nb')

    if nearest_test
      let test_string = split(getline(nearest_test), '["'']')[1]
      let test_string = escape(test_string, '#')

      return test_string
    endif
  endif
endfunction

function! s:format_test_name(name)
  return substitute(tolower(a:name), ' ', '_', 'g')
endfunction

function! neoterm#test#minitest#result_handler(line)
  let counters = matchlist(
        \ a:line,
        \ '\(\d\+\|no\) failures\?, \(\d\+\|no\) errors\?'
        \ )

  if !empty(counters)
    let failures = counters[1]
    let errors = counters[2]

    if str2nr(failures) == 0 && str2nr(errors) == 0
      let g:neoterm_statusline = g:neoterm_test_status.success
    else
      let g:neoterm_statusline = g:neoterm_test_status.failed
    end
  end
endfunction
