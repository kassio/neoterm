let g:neoterm.repl = { 'loaded': 0 }

function! g:neoterm.repl.instance() abort
  if !has_key(l:self, 'instance_id')
    if !g:neoterm.has_any()
      call neoterm#new({ 'handlers': neoterm#repl#handlers() })
    end

    call neoterm#repl#term(g:neoterm.last_id)
  end

  return g:neoterm.instances[l:self.instance_id]
endfunction

function! neoterm#repl#handlers() abort
  return { 'on_exit': function('s:repl_result_handler') }
endfunction

function! s:repl_result_handler(...) abort
  let g:neoterm.repl.loaded = 0
endfunction

function! neoterm#repl#term(id) abort
  if has_key(g:neoterm.instances, a:id)
    let g:neoterm.repl.instance_id = a:id
    let g:neoterm.repl.loaded = 1
    if !empty(get(g:, 'neoterm_repl_command', ''))
          \ && g:neoterm_auto_repl_cmd
          \ && !g:neoterm_direct_open_repl
      call neoterm#exec({
            \ 'cmd': g:neoterm_repl_command,
            \ 'target': g:neoterm.repl.instance().id
            \ })
    end
  else
    echoe printf('There is no %s term.', a:id)
  end
endfunction

<<<<<<< HEAD
function! neoterm#repl#set(value)
  if type(a:value) == v:t_list
    let g:neoterm_repl_command = add(a:value, g:neoterm_eof)
  else
    let g:neoterm_repl_command = [a:value, g:neoterm_eof]
  endif
||||||| e011fa1
function! neoterm#repl#set(value)
  let g:neoterm_repl_command = a:value
=======
function! neoterm#repl#set(value) abort
  if type(a:value) == v:t_list
    let g:neoterm_repl_command = add(a:value, g:neoterm_eof)
  else
    let g:neoterm_repl_command = [a:value, g:neoterm_eof]
  endif
>>>>>>> upstream/master
endfunction

function! neoterm#repl#selection() abort
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

function! neoterm#repl#line(...) abort
  let l:lines = getline(a:1, a:2)
  call g:neoterm.repl.exec(l:lines)
endfunction

function! neoterm#repl#opfunc(type) abort
  let [l:lnum1, l:col1] = getpos("'[")[1:2]
  let [l:lnum2, l:col2] = getpos("']")[1:2]
  let l:lines = getline(l:lnum1, l:lnum2)
  if a:type ==# 'char'
    let l:lines[-1] = l:lines[-1][:l:col2 - 1]
    let l:lines[0] = l:lines[0][l:col1 - 1:]
  endif
  call g:neoterm.repl.exec(l:lines)
endfunction

<<<<<<< HEAD
function! g:neoterm.repl.exec(command)
  let l:ft_exec = printf('neoterm#repl#%s#exec', &filetype)
  try
    let ExecByFiletype = function(l:ft_exec)
    call ExecByFiletype(a:command)
  catch /^Vim\%((\a\+)\)\=:E117/
    call g:neoterm.repl.instance().exec(add(a:command, g:neoterm_eof))
  endtry
||||||| e011fa1
function! g:neoterm.repl.exec(command)
  call g:neoterm.repl.instance().exec(add(a:command, g:neoterm_eof))
=======
function! g:neoterm.repl.exec(command) abort
  let l:ft_exec = printf('neoterm#repl#%s#exec', &filetype)
  try
    let ExecByFiletype = function(l:ft_exec)
    call ExecByFiletype(a:command)
  catch /^Vim\%((\a\+)\)\=:E117/
    call g:neoterm.repl.instance().exec(add(a:command, g:neoterm_eof))
  endtry
>>>>>>> upstream/master
endfunction
