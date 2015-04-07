" Public: Executes a command on terminal. Evaluates any "%" inside the command
" to the full path of the current file.
function! neoterm#do(command)
  let command = substitute(a:command, '%', expand('%:p'), 'g')

  call <sid>term_exec([command, ''])
endfunction

" Internal: Loads a terminal, if it is not loaded, and execute a list of
" commands.
function! s:term_exec(list)
  if !exists('g:neoterm_current_id')
    let current_window = winnr()
    if g:neoterm_position == 'horizontal'
      let split_cmd = "botright new | term"
    else
      let split_cmd = "botright vert new | term"
    end

    exec split_cmd | exec current_window . "wincmd w | set noim"
  end

  call jobsend(g:neoterm_current_id, a:list)
endfunction

" Internal: Loads a REPL, if it is not loaded, and execute the given list of
" commands. The REPL public API are the commands REPLSendLine and
" REPLSendSelection.
function! neoterm#repl(command)
  if exists('g:neoterm_repl_command') && !exists('g:neoterm_repl_loaded')
    call neoterm#do(g:neoterm_repl_command)
    let g:neoterm_repl_loaded = 1
  end

  call <sid>term_exec(add(a:command, ''))
endfunction

function! neoterm#horizontal_term(args)
  let l:term_default_pos = g:neoterm_position
  let g:neoterm_position = 'horizontal'

  call neoterm#do(a:args)
  let g:neoterm_position = l:term_default_pos
endfunction

function! neoterm#vertical_term(args)
  let l:term_default_pos = g:neoterm_position
  let g:neoterm_position = 'vertical'

  call neoterm#do(a:args)
  let g:neoterm_position = l:term_default_pos
endfunction

function! neoterm#test_runner(scope)
  let Fn = function('neoterm#' . g:neoterm_test_lib)
  let g:neoterm_last_test_command = g:neoterm_clear_cmd . ';' . Fn(a:scope)

  call <sid>term_exec([g:neoterm_last_test_command, ''])
endfunction

function! neoterm#test_rerun()
  if exists('g:neoterm_last_test_command')
    call <sid>term_exec([g:neoterm_last_test_command, ''])
  else
    echo 'No test has been runned.'
  endif
endfunction

function! neoterm#rspec(scope)
  let command = 'rspec'

  if a:scope == 'file'
    let command .= ' ' . expand('%:p')
  elseif a:scope == 'current'
    let command .= ' ' . expand('%:p') . ':' . line('.')
  endif

  return command
endfunction

function! neoterm#minitest(scope)
  if a:scope == 'all'
    let command = 'rake test'
  elseif a:scope == 'file'
    let command = 'ruby -Ilib:test ' . expand('%:p')
  elseif a:scope == 'current'
    let command = 'ruby -Ilib:test ' . expand('%:p') . ' -n /' . <sid>get_current_minitest() . '/'
  endif

  return command
endfunction

function! s:get_current_minitest()
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
