function! neoterm#term#load()
  if !has_key(g:neoterm, 'prototype')
    if has('nvim')
      let l:term = neoterm#term#neovim#()
    elseif has('terminal')
      let l:term = neoterm#term#vim#()
    else
      throw "neoterm does not support your vim/neovim version"
    end

    let s:term.termsend = l:term.termsend
    let g:neoterm.new = l:term.new
    let g:neoterm.prototype = s:term
  end
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
  call l:self.termsend(l:self.termid, a:command)
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
  call neoterm#destroy(l:self)
endfunction
