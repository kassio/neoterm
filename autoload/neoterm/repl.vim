" Internal: Sets the current REPL command.
function! neoterm#repl#set(value)
  if !exists('g:neoterm_repl_command')
    let g:neoterm_repl_command = a:value
  end
endfunction

" Internal: Executes the current line within a REPL.
function! neoterm#repl#line()
  call <sid>repl_exec([getline('.')])
endfunction

" Internal: Executes the current selection within a REPL.
function! neoterm#repl#selection(line1, line2)
  call <sid>repl_exec(getline(a:line1, a:line2))
endfunction

" Internal: Open the REPL, if needed, and executes the given command.
function! s:repl_exec(command)
  if !exists('g:neoterm_repl_loaded')
    call neoterm#do(g:neoterm_repl_command)
    let g:neoterm_repl_loaded = 1
  end

  call neoterm#exec(add(a:command, ''))
endfunction
