function! neoterm#test#elixir#run(scope)
  let command = 'mix test'
  let path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')

  if a:scope == 'file'
    let command .= ' ' . path
  elseif a:scope == 'current'
    let command .= ' ' . s:current(path)
  endif

  return command
endfunction

function! s:current(path)
  let line = getline('.')

  if line =~ 'describe'
    return '--only describe:"' . matchstr(line, 'describe\s*"\zs.*\ze"') . '"'
  else
    return a:path . ':' . line('.')
  end
endfunction

function! neoterm#test#elixir#result_handler(line)
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
