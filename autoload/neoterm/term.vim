function! neoterm#term#load()
  if !has_key(g:neoterm, 'prototype')
    if has('nvim')
      let l:term = neoterm#term#neovim#()
    elseif has('terminal')
      let l:term = neoterm#term#vim#()
    else
      throw 'neoterm does not support your vim/neovim version'
    end

    let s:term.termsend = l:term.termsend
    let g:neoterm.new = l:term.new
    let g:neoterm.prototype = s:term
  end
endfunction

let s:term = {}

function! s:term.vim_exec(cmd)
  let l:winnr = bufwinnr(l:self.buffer_id)
  if l:winnr > 0
    let l:win_id = exists('*win_getid') ? win_getid() : 0
    exec printf('%swincmd w', l:winnr)
    call execute(a:cmd)
    call win_gotoid(l:win_id)
  end
endfunction

function! s:term.normal(cmd)
  call l:self.vim_exec(printf('normal! %s', a:cmd))
endfunction

function! s:term.exec(command)
  call l:self.termsend(l:self.termid, a:command)
  if g:neoterm_autoscroll
    call l:self.normal('G')
  end
endfunction

function! s:term.on_stdout(...)
  if has_key(l:self.handlers, 'on_stdout')
    call l:self.handlers['on_stdout'](a:)
  end
endfunction

function! s:term.on_stderr(...)
  if has_key(l:self.handlers, 'on_stderr')
    call l:self.handlers['on_stderr'](a:)
  end
endfunction

function! s:term.on_exit(...)
  if has_key(l:self.handlers, 'on_exit')
    call l:self.handlers['on_exit'](a:)
  end
  call neoterm#destroy(l:self)
endfunction
