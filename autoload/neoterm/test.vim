" Public: Runs the current test lib with the given scope.
function! neoterm#test#run(scope)
  let g:neoterm_last_test_command = <sid>get_test_command(a:scope)
  " silent call neoterm#exec([g:neoterm_clear_cmd, g:neoterm_last_test_command, ''])

  new
  call termopen(
        \   [&sh, &shcf, g:neoterm_last_test_command],
        \   {
        \     'name': 'NEOTERM-TEST',
        \     'on_stdout': function('s:test_result'),
        \     'on_stderr': function('s:test_result'),
        \     'on_exit': function('s:test_result')
        \   }
        \ )
  let g:neoterm_statusline = 'RUNNING'
endfunction

" Public: Re-run the last test command.
function! neoterm#test#rerun()
  if exists('g:neoterm_last_test_command')
    "silent call neoterm#exec([g:neoterm_last_test_command, ''])

    new
    call termopen(
          \   [&sh, &shcf, g:neoterm_last_test_command],
          \   {
          \     'name': 'NEOTERM-TEST',
          \     'on_stdout': function('s:test_result'),
          \     'on_stderr': function('s:test_result'),
          \     'on_exit': function('s:test_result')
          \   }
          \ )
    let g:neoterm_statusline = 'RUNNING'
  else
    echo 'No test has been runned.'
  endif
endfunction

" Internal: Get the command with the current test lib.
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

function! s:test_result(job_id, data, event)
  if a:event == 'exit'
    let g:neoterm_statusline = a:data == '0' ? 'SUCCESS' : 'FAILED'
  else
    let Fn = function('neoterm#test#' . g:neoterm_test_lib . '#result')
    call Fn(a:data[0])
  end
endfunction

function! neoterm#test#statusline(...)
  let result = !empty(a:000) ? a:1 : ''

  if g:neoterm_statusline =~? result
    return '['.g:neoterm_statusline.']'
  else
    return ''
  end
endfunction
