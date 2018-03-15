let g:neoterm.repl = { 'loaded': 0 }

function! g:neoterm.repl.instance()
  if !has_key(l:self, 'instance_id')
    if !g:neoterm.has_any()
      call neoterm#new({ 'handlers': neoterm#repl#handlers() })
    end

    call neoterm#repl#term(g:neoterm.last_id)
  end

  return g:neoterm.instances[l:self.instance_id]
endfunction

function! neoterm#repl#handlers()
  return { 'on_exit': function('s:repl_result_handler') }
endfunction

function! s:repl_result_handler(termid, data, event)
  let g:neoterm.repl.loaded = 0
endfunction

function! neoterm#repl#term(id)
  if has_key(g:neoterm.instances, a:id)
    let g:neoterm.repl.instance_id = a:id
    let g:neoterm.repl.loaded = 1

    if !empty(get(g:, 'neoterm_repl_command', ''))
          \ && g:neoterm_auto_repl_cmd
          \ && !g:neoterm_direct_open_repl
      call neoterm#exec({
            \ 'cmd': [g:neoterm_repl_command, g:neoterm_eof],
            \ 'target': g:neoterm.repl.instance().id
            \ })
    end
  else
    echoe printf('There is no %s term.', a:id)
  end
endfunction

function! neoterm#repl#set(value)
  let g:neoterm_repl_command = a:value
endfunction

function! neoterm#repl#selection()
  let [l:lnum1, l:col1] = getpos("'<")[1:2]
  let [l:lnum2, l:col2] = getpos("'>")[1:2]
  if &selection ==# 'exclusive'
    let l:col2 -= 1
  endif
  let l:lines = getline(l:lnum1, l:lnum2)
  let l:lines[-1] = l:lines[-1][:l:col2 - 1]
  let l:lines[0] = l:lines[0][l:col1 - 1:]
  call g:neoterm.repl.exec(l:lines)
endfunction

function! neoterm#repl#line(...)
  let l:lines = getline(a:1, a:2)
  call g:neoterm.repl.exec(l:lines)
endfunction

function! neoterm#repl#opfunc(type)
  let [l:lnum1, l:col1] = getpos("'[")[1:2]
  let [l:lnum2, l:col2] = getpos("']")[1:2]
  let l:lines = getline(l:lnum1, l:lnum2)
  if a:type ==# 'char'
    let l:lines[-1] = l:lines[-1][:l:col2 - 1]
    let l:lines[0] = l:lines[0][l:col1 - 1:]
  endif
  call g:neoterm.repl.exec(l:lines)
endfunction

function! g:neoterm.repl.exec(command)
  call g:neoterm.repl.instance().exec(add(a:command, g:neoterm_eof))
endfunction
