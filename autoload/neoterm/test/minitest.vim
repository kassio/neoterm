function! neoterm#test#minitest#run(scope)
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

" 8 runs, 11 assertions, 1 failure, no errors, no skips
" 8 runs, 11 assertions, no failures, no errors, no skips
function! neoterm#test#minitest#result(line)
  let counters = matchlist(
        \ a:line,
        \ '\(\d\+\|no\) failures\?, \(\d\+\|no\) errors\?, \(\d\+\|no\) skips\?'
        \ )

  if !empty(counters)
    let failures = counters[1]
    let errors = counters[2]
    let skips = counters[3]

    if failures == 'no' && errors == 'no'
      let g:neoterm_statusline = 'SUCCESS'
    else
      let g:neoterm_statusline = 'FAILED'
    end

    if skips != 'no'
      let g:neoterm_statusline .= '*'
    end
  end
endfunction
