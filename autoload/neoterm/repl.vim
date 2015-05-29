function! neoterm#repl#set(value)
  if !exists('g:neoterm_repl_command')
    let g:neoterm_repl_command = a:value
  end
endfunction

function! neoterm#repl#line()
  call <sid>repl_exec([getline('.')])
endfunction

function! neoterm#repl#selection()
  call <sid>repl_exec(<sid>get_visual_lines())
endfunction

function! neoterm#repl#all()
  call <sid>repl_exec(getline(0, line('$')))
endfunction

function! s:repl_exec(command)
  if !exists('g:neoterm_repl_loaded')
    call neoterm#do(g:neoterm_repl_command)
    let g:neoterm_repl_loaded = 1
  end

  call neoterm#exec(add(a:command, ''))
endfunction

function! s:get_visual_lines()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]

  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][:col2 - 1]
  let lines[0] = lines[0][col1 - 1:]

  return lines
endfunction
