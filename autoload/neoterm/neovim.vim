function! neoterm#neovim#load()
  if !has_key(g:neoterm, 'prototype')
    let g:neoterm.new = function('s:new')
    let g:neoterm.prototype = s:term
  end
endfunction

function! s:new(instance)
  if g:neoterm_direct_open_repl
    let l:termid = termopen(g:neoterm_repl_command, a:instance)
  else
    let l:termid = termopen(g:neoterm_shell, a:instance)
  end

  return l:termid
endfunction

let s:term = {}

function! s:term.focus_exec(cmd)
  let l:winnr = bufwinnr(l:self.buffer_id)
  if l:winnr > 0
    let l:win_id = exists('*win_getid') ? win_getid() : 0
    exec printf('%swincmd w', l:winnr)
    call a:cmd()
    call win_gotoid(l:win_id)
  end
endfunction

function! s:term.vim_exec(cmd)
  call l:self.focus_exec({ -> execute(a:cmd) })
endfunction

function! s:term.normal(cmd)
  call l:self.vim_exec(printf('normal! %s', a:cmd))
endfunction

function! s:term.do(command)
  call l:self.exec([a:command, g:neoterm_eof])
endfunction

function! s:term.exec(command)
  call jobsend(l:self.termid, a:command)
  if g:neoterm_autoscroll
    call l:self.normal('G')
  end
endfunction

function! s:term.on_stdout(termid, data, event)
  if has_key(l:self.handlers, 'on_stdout')
    call l:self.handlers['on_stdout'](a:termid, a:data, a:event)
  end
endfunction

function! s:term.on_stderr(termid, data, event)
  if has_key(l:self.handlers, 'on_stderr')
    call l:self.handlers['on_stderr'](a:termid, a:data, a:event)
  end
endfunction

function! s:term.on_exit(termid, data, event)
  if has_key(l:self.handlers, 'on_exit')
    call l:self.handlers['on_exit'](a:termid, a:data, a:event)
  end

  call l:self.destroy()
endfunction

function! s:term.destroy()
  if has_key(g:neoterm, 'repl') && get(g:neoterm.repl, 'instance_id') ==# l:self.id
    call remove(g:neoterm.repl, 'instance_id')
  end

  if has_key(g:neoterm.instances, l:self.id)
    call neoterm#close({ 'force': 1, 'target': l:self.id })
    call remove(g:neoterm.instances, l:self.id)
  end
endfunction
