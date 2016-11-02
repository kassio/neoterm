let g:neoterm.repl = {
      \ "loaded": 0
      \ }

function! g:neoterm.repl.instance()
  if !has_key(self, "instance_id")
    if !g:neoterm.has_any()
      call neoterm#new(neoterm#repl#handlers())
    end

    call neoterm#repl#term(g:neoterm.last_id)
  end

  return g:neoterm.instances[self.instance_id]
endfunction

function! neoterm#repl#handlers()
  return  {
        \   "on_exit": function("s:test_result_handler")
        \ }
endfunction


function! s:test_result_handler(job_id, data, event)
  let g:neoterm.repl.loaded = 0
endfunction

function! neoterm#repl#term(id)
  if has_key(g:neoterm.instances, a:id)
    let g:neoterm.repl.instance_id = a:id
    let g:neoterm.repl.loaded = 1
  else
    echoe "There is no ".a:id." term."
  end
endfunction

" Internal: Sets the current REPL command.
function! neoterm#repl#set(value)
  let g:neoterm_repl_command = a:value
endfunction

" Internal: Executes the current selection within a REPL.
function! neoterm#repl#selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][:col2 - 1]
  let lines[0] = lines[0][col1 - 1:]
  call g:neoterm.repl.exec(lines)
endfunction

" Internal: Executes the current line within a REPL.
function! neoterm#repl#line(...)
  let lines = getline(a:1, a:2)
  call g:neoterm.repl.exec(lines)
endfunction

" Internal: Open the REPL, if needed, and executes the given command.
function! g:neoterm.repl.exec(command)
  if !self.loaded
    if !empty(get(g:, "neoterm_repl_command", ""))
      call self.instance().do(g:neoterm_repl_command)
    end
    let self.loaded = 1
  end

  call g:neoterm.repl.instance().exec(add(a:command, g:neoterm_eof))
endfunction
