let g:neoterm.test = {}

function! g:neoterm.test.instance()
  if !has_key(self, "instance_id")
    if exists("g:neoterm_test_before_all")
      let BeforeAll = function(g:neoterm_test_before_all)
      echom 'neoterm hooked(BeforeAll)'
      call BeforeAll()
    end

    if !g:neoterm.has_any()
      call neoterm#window#create(neoterm#test#handlers(), 'test')
    end

    call neoterm#test#term(g:neoterm.last_id)
  end

  return g:neoterm.instances[self.instance_id]
endfunction

function! neoterm#test#term(id)
  if has_key(g:neoterm.instances, a:id)
    let g:neoterm.test.instance_id = a:id
  else
    echoe "There is no ".a:id." term."
  end
endfunction

" Public: Runs the current test lib with the given scope.
function! neoterm#test#run(scope)
  let g:neoterm.test.last_command = s:get_test_command(a:scope)
  call s:run(g:neoterm.test.last_command)
endfunction

" Public: Re-run the last test command.
function! neoterm#test#rerun()
  if exists("g:neoterm.test.last_command")
    call s:run(g:neoterm.test.last_command)
  else
    echoe "No test has been runned."
  end
endfunction

function! s:run(command)
  call g:neoterm.test.instance().clear()
  call g:neoterm.test.instance().exec([a:command, g:neoterm_eof])
  let g:neoterm_statusline = g:neoterm_test_status.running

  if !g:neoterm_run_tests_bg && !neoterm#tab_has_neoterm()
    call g:neoterm.test.instance().open()
  end
endfunction

" Internal: Get the command with the current test lib.
function! s:get_test_command(scope)
  if exists("b:neoterm_test_lib") && b:neoterm_test_lib != ""
    let Fn = function("neoterm#test#" . b:neoterm_test_lib . "#run")
  elseif exists("g:neoterm_test_lib") && g:neoterm_test_lib != ""
    let Fn = function("neoterm#test#" . g:neoterm_test_lib . "#run")
  else
    echoe "No test lib set."
    return ""
  end

  return Fn(a:scope)
endfunction

" Internal: Builds the dictionary with all test event handlers.
function! neoterm#test#handlers()
  return  {
        \   "on_stdout": function("s:test_result_handler"),
        \   "on_stderr": function("s:test_result_handler"),
        \   "on_exit": function("s:test_result_handler")
        \ }
endfunction

" Internal: Handle the test results using the current test library test
" result"s handler.
function! s:test_result_handler(job_id, data, event)
  " Only change statusline if tests were running
  if g:neoterm_statusline != g:neoterm_test_status.running
    return
  end

  if a:event == "exit"
    let g:neoterm_statusline = a:data == "0" ?
          \ g:neoterm_test_status.success :
          \ g:neoterm_test_status.failed
  else
    try
      let Fn = function("neoterm#test#" . g:neoterm_test_lib . "#result_handler")
      for line in a:data
        call Fn(line)
      endfor
    catch "E117"
      let g:neoterm_statusline = ""
    endtry
  end

  redrawstatus!
  call s:raise_term_buffer()
  call s:focus_term_buffer()
  call s:close_term_buffer()
endfunction

function! neoterm#test#status(status)
  if g:neoterm_statusline == g:neoterm_test_status[a:status]
    return printf(g:neoterm_test_status_format, g:neoterm_statusline)
  else
    return ""
  end
endfunction

function! s:raise_term_buffer()
  if !neoterm#tab_has_neoterm()
    if g:neoterm_statusline == g:neoterm_test_status.failed
          \ && g:neoterm_raise_when_tests_fail

      call g:neoterm.test.instance().open()
    end
  end
endfunction

function! s:focus_term_buffer()
  if g:neoterm_statusline == g:neoterm_test_status.failed
        \ && g:neoterm_focus_when_tests_fail
    call g:neoterm.test.instance().focus()
  end
endfunction

function! s:close_term_buffer()
  if neoterm#tab_has_neoterm()
    if g:neoterm_statusline == g:neoterm_test_status.success
          \ && g:neoterm_close_when_tests_succeed

      call g:neoterm.test.instance().close()
    end
  end
endfunction
