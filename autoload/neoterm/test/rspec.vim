function! neoterm#test#rspec#run(scope)
  let path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')

  if exists('g:neoterm_rspec_lib_cmd')
    let command = g:neoterm_rspec_lib_cmd
  else
    let command = 'bundle exec rspec'
  end

  if a:scope == 'file'
    let command .= ' ' . path
  elseif a:scope == 'current'
    let command .= ' ' . path . ':' . line('.')
  endif

  return command
endfunction

function! neoterm#test#rspec#result_handler(line)
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
