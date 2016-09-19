function! neoterm#test#testrbl#run(scope)
  if a:scope == 'all'
    return 'rake test'
  else
    let path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')
    let command = 'testrbl'

    if a:scope == 'file'
      let command .= ' ' . path
    elseif a:scope == 'current'
      let command .= ' ' . path . ':' . line('.')
    endif

    return command
  end
endfunction

function! neoterm#test#testrbl#result_handler(line)
  let counters = matchlist(
        \ a:line,
        \ '\(\d\+\|no\) failures\?'
        \ )

  if !empty(counters)
    let failures = counters[1]

    if str2nr(failures) == 0
      let g:neoterm_statusline = g:neoterm_test_status.success
    else
      let g:neoterm_statusline = g:neoterm_test_status.failed
    end
  end
endfunction
