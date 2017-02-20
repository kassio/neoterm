let g:neoterm.term = {}

function! g:neoterm.term.new(handlers)
  let id = g:neoterm.next_id()
  let name = ";#neoterm-".id
  let instance = extend(copy(self), {
        \ "id": id,
        \ })

  let instance.handlers = a:handlers

  let instance.job_id = termopen(g:neoterm_shell . name, instance)
  let instance.buffer_id = bufnr("")
  let g:neoterm.instances[instance.id] = instance

  let b:term_title = 'neoterm-'.id

  return instance
endfunction

function! g:neoterm.term.mappings()
  if has_key(g:neoterm.instances, self.id)
    let instance = "g:neoterm.instances.".self.id
    exec "command! -complete=shellcmd Topen".self.id." silent call ".instance.".open()"
    exec "command! -complete=shellcmd Tclose".self.id." silent call ".instance.".close()"
    exec "command! -complete=shellcmd Tclear".self.id." silent call ".instance.".clear()"
    exec "command! -complete=shellcmd Tkill".self.id." silent call ".instance.".kill()"
    exec "command! -complete=shellcmd -nargs=+ T".self.id." silent call ".instance.".do(<q-args>)"
  else
    echoe "There is no ".self.id." neoterm."
  end
endfunction

function! g:neoterm.term.open()
  call neoterm#window#reopen(self.buffer_id)
endfunction

function! g:neoterm.term.focus()
  exec bufwinnr(self.buffer_id) . "wincmd w"
endfunction

function! g:neoterm.term.close()
  if bufwinnr(self.buffer_id) > 0
    if g:neoterm_keep_term_open
      exec bufwinnr(self.buffer_id) . "hide"
    else
      exec self.buffer_id . "bdelete!"
    end
  end
endfunction

function! g:neoterm.term.do(command)
  call self.exec([a:command, g:neoterm_eof])
endfunction

function! g:neoterm.term.exec(command)
  call jobsend(self.job_id, a:command)
endfunction

function! g:neoterm.term.clear()
  call self.exec("\<c-l>")
endfunction

function! g:neoterm.term.kill()
  call self.exec("\<c-c>")
endfunction

function! g:neoterm.term.on_stdout(job_id, data, event)
  if has_key(self.handlers, "on_stdout")
    call self.handlers["on_stdout"](a:job_id, a:data, a:event)
  end
endfunction

function! g:neoterm.term.on_stderr(job_id, data, event)
  if has_key(self.handlers, "on_stderr")
    call self.handlers["on_stderr"](a:job_id, a:data, a:event)
  end
endfunction

function! g:neoterm.term.on_exit(job_id, data, event)
  if has_key(self.handlers, "on_exit")
    call self.handlers["on_exit"](a:job_id, a:data, a:event)
  end

  call self.destroy()
endfunction

function! g:neoterm.term.destroy()
  if has_key(g:neoterm, "repl") && get(g:neoterm.repl, "instance_id") == self.id
    call remove(g:neoterm.repl, "instance_id")
  end

  if has_key(g:neoterm.instances, self.id)
    call self.close()
    call remove(g:neoterm.instances, self.id)
  end

  let g:neoterm.last_id = get(keys(g:neoterm.instances), -1)
endfunction
