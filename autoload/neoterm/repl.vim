let g:neoterm.repl = {}

function! g:neoterm.repl.instance()
  if !has_key(self, "instance_id")
    if !g:neoterm.has_any()
      call neoterm#new(neoterm#test#handlers())
    end

    call neoterm#repl#term(g:neoterm.last_id)
  end

  return g:neoterm.instances[self.instance_id]
endfunction

function! neoterm#repl#term(id)
  if has_key(g:neoterm.instances, a:id)
    let g:neoterm.repl.instance_id = a:id
  else
    echoe "There is no ".a:id." term."
  end
endfunction

" Internal: Sets the current REPL command.
function! neoterm#repl#set(value)
  let g:neoterm_repl_command = a:value
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
    call g:neoterm.repl.instance().do(g:neoterm_repl_command)
    let g:neoterm_repl_loaded = 1
  end

  call g:neoterm.repl.instance().exec(add(a:command, ""))
endfunction
