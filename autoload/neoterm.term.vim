let g:neoterm.term = {}

function! g:neoterm.term.new(origin, handlers)
  let l:id = g:neoterm.next_id()
  let l:name = ';#neoterm-'.l:id
  let l:instance = extend(copy(l:self), {
        \ 'id': l:id,
        \ })

  let l:instance.handlers = a:handlers
  let l:instance.origin = a:origin

  if g:neoterm_direct_open_repl
    let l:instance.job_id = termopen(g:neoterm_repl_command . l:name, l:instance)
  else
    let l:instance.job_id = termopen(g:neoterm_shell . l:name, l:instance)
  end

  let l:instance.buffer_id = bufnr('')
  let g:neoterm.instances[l:instance.id] = l:instance

  let b:term_title = 'neoterm-'.l:id

  call l:instance.mappings()

  return l:instance
endfunction

function! g:neoterm.term.mappings()
  if has_key(g:neoterm.instances, l:self.id)
    let l:instance = printf('g:neoterm.instances.%s', l:self.id)
    exec printf('command! -bar Topen%s silent call %s.open()', l:self.id, l:instance)
    exec printf('command! -bang -bar Tclose%s silent call %s.close(<bang>0)', l:self.id, l:instance)
    exec printf('command! Tclear%s silent call %s.clear()', l:self.id, l:instance)
    exec printf('command! Tkill%s silent call %s.kill()', l:self.id, l:instance)
    exec printf('command! -complete=shellcmd -nargs=+ T%s silent call %s.do(<q-args>)', l:self.id, l:instance)
  else
    echoe printf('There is no %s neoterm.', l:self.id)
  end
endfunction

function! g:neoterm.term.open()
  let l:self.origin = exists('*win_getid') ? win_getid() : 0
  call neoterm#window#reopen(l:self)
endfunction

function! g:neoterm.term.focus_exec(cmd)
  let l:winnr = bufwinnr(l:self.buffer_id)
  if l:winnr > 0
    let l:win_id = exists('*win_getid') ? win_getid() : 0
    exec printf('%swincmd w', l:winnr)
    call a:cmd()
    call win_gotoid(l:win_id)
  end
endfunction

function! g:neoterm.term.vim_exec(cmd)
  call l:self.focus({ -> execute(a:cmd) })
endfunction

function! g:neoterm.term.normal(cmd)
  call l:self.vim_exec(printf('normal! %s', a:cmd))
endfunction

function! g:neoterm.term.close(...)
  try
    let l:force = get(a:, '1', 0)
    if bufwinnr(l:self.buffer_id) > 0
      if l:force || !g:neoterm_keep_term_open
        exec printf('%sbdelete!', l:self.buffer_id)
      else
        exec printf('%shide', bufwinnr(l:self.buffer_id))
      end
    end

    if l:self.origin
      call win_gotoid(l:self.origin)
    end
  catch /^Vim\%((\a\+)\)\=:E444/
    " noop
    " Avoid messages when the terminal is the last window
  endtry
endfunction

function! g:neoterm.term.do(command)
  call l:self.exec([a:command, g:neoterm_eof])
endfunction

function! g:neoterm.term.exec(command)
  call jobsend(l:self.job_id, a:command)
  if g:neoterm_autoscroll
    call l:self.normal('G')
  end
endfunction

function! g:neoterm.term.clear()
  call l:self.exec("\<c-l>")
endfunction

function! g:neoterm.term.kill()
  call l:self.exec("\<c-c>")
endfunction

function! g:neoterm.term.on_stdout(job_id, data, event)
  if has_key(l:self.handlers, 'on_stdout')
    call l:self.handlers['on_stdout'](a:job_id, a:data, a:event)
  end
endfunction

function! g:neoterm.term.on_stderr(job_id, data, event)
  if has_key(l:self.handlers, 'on_stderr')
    call l:self.handlers['on_stderr'](a:job_id, a:data, a:event)
  end
endfunction

function! g:neoterm.term.on_exit(job_id, data, event)
  if has_key(l:self.handlers, 'on_exit')
    call l:self.handlers['on_exit'](a:job_id, a:data, a:event)
  end

  call l:self.destroy()
endfunction

function! g:neoterm.term.destroy()
  if has_key(g:neoterm, 'repl') && get(g:neoterm.repl, 'instance_id') ==# l:self.id
    call remove(g:neoterm.repl, 'instance_id')
  end

  if has_key(g:neoterm.instances, l:self.id)
    call l:self.close()
    call remove(g:neoterm.instances, l:self.id)
  end

  let g:neoterm.last_id = get(keys(g:neoterm.instances), -1)
endfunction
