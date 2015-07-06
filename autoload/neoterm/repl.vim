" Internal: Sets the current REPL command.
function! neoterm#repl#set(value)
  if !exists('g:neoterm_repl_command')
    let g:neoterm_repl_command = a:value
  end
endfunction

" Internal: Executes the current selection within a REPL.
function! neoterm#repl#selection(...)
  if getpos("'>") != [0, 0, 0, 0]
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    call setpos("'>", [0, 0, 0, 0])
    call setpos("'<", [0, 0, 0, 0])

    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][:col2 - 1]
    let lines[0] = lines[0][col1 - 1:]
  else
    let lines = getline(a:1, a:2)
  end

  call <sid>repl_exec(lines)
endfunction

" Internal: Open the REPL, if needed, and executes the given command.
function! s:repl_exec(command)
  if !exists('g:neoterm_repl_loaded')
    call neoterm#do(g:neoterm_repl_command)
    let g:neoterm_repl_loaded = 1
  end

  call neoterm#exec(add(a:command, ''))
endfunction
