" Public: Runs the current test lib with the given scope.
function! neoterm#test#run(scope)
  let g:neoterm_last_test_command = <sid>get_test_command(a:scope)
  call <sid>run(g:neoterm_last_test_command)
endfunction

" Public: Re-run the last test command.
function! neoterm#test#rerun()
  if exists('g:neoterm_last_test_command')
    call <sid>run(g:neoterm_last_test_command)
  else
    echo 'No test has been runned.'
  endif
endfunction

function! s:run(command)
  let should_hide = !neoterm#tab_has_neoterm() && g:neoterm_run_tests_bg
  let g:neoterm_statusline = g:neoterm_test_status.running

  call neoterm#exec(
        \ [g:neoterm_clear_cmd, a:command, ''],
        \   {
        \     'on_stdout': function('s:test_result'),
        \     'on_stderr': function('s:test_result'),
        \     'on_exit': function('s:test_result')
        \   }
        \ )

  if should_hide
    call neoterm#close_buffer(g:neoterm_buffer_id)
  end
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
    let g:neoterm_statusline = a:data == '0' ?
          \ g:neoterm_test_status.success :
          \ g:neoterm_test_status.failed
  else
    try
      let Fn = function('neoterm#test#' . g:neoterm_test_lib . '#result')
      for line in a:data
        call Fn(line)
      endfor
    catch 'E117'
      return
    endtry
  end

  call <sid>raise_term_buffer()
endfunction

function! neoterm#test#status(status)
  redrawstatus!

  if g:neoterm_statusline == g:neoterm_test_status[a:status]
    return printf(g:neoterm_test_status_format, g:neoterm_statusline)
  else
    return ''
  end
endfunction

function! s:raise_term_buffer()
  if g:neoterm_statusline == g:neoterm_test_status.failed
        \ && g:neoterm_raise_when_tests_fail

    let current_window = winnr()
    call neoterm#show()
    silent exec current_window . "wincmd w | set noinsertmode"
  end
endfunction
