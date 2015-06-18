function! neoterm#repl#set(value)
  if !exists('g:neoterm_repl_command')
    let g:neoterm_repl_command = a:value
  end
endfunction

function! neoterm#repl#line()
  call <sid>repl_exec([getline('.')])
endfunction

function! neoterm#repl#selection(line1, line2)
  call <sid>repl_exec(getline(a:line1, a:line2))
endfunction

function! s:repl_exec(command)
  if !exists('g:neoterm_repl_loaded')
    call neoterm#do(g:neoterm_repl_command)
    let g:neoterm_repl_loaded = 1
  end

  call neoterm#exec(add(a:command, ''))
endfunction
