function! neoterm#term#new(opts) abort
  call neoterm#term#load()

  return extend(
        \   copy(g:neoterm.prototype),
        \   neoterm#default#opts(a:opts)
        \ )
endfunction

function! neoterm#term#load() abort
  if !has_key(g:neoterm, 'prototype')
    if has('nvim')
      let l:adapter = neoterm#term#neovim#()
    elseif has('terminal')
      let l:adapter = neoterm#term#vim#()
    else
      throw 'neoterm does not support your vim/neovim version'
    end

    call extend(s:term, copy(l:adapter), 'error')

    let g:neoterm.prototype = s:term
  end
endfunction

let s:term = {}

function! s:term.vim_exec(cmd) abort
  let l:winnr = bufwinnr(l:self.buffer_id)
  if l:winnr > 0
    let l:win_id = exists('*win_getid') ? win_getid() : 0
    exec printf('%swincmd w', l:winnr)
    call execute(a:cmd)
    call win_gotoid(l:win_id)
  end
endfunction

function! s:term.normal(cmd) abort
  call l:self.vim_exec(printf('normal! %s', a:cmd))
endfunction

function! s:term.exec(command) abort
  if !empty(g:neoterm_command_prefix)
    call l:self.termsend(l:self.termid, [g:neoterm_command_prefix . a:command[0]] + a:command[1:])
  else
    call l:self.termsend(l:self.termid, a:command)
  end
  if g:neoterm_autoscroll
    call l:self.normal('G')
  end
endfunction

function! s:term.on_stdout(...) abort
  if has_key(l:self.handlers, 'on_stdout')
    call l:self.handlers['on_stdout'](a:)
  end
endfunction

function! s:term.on_stderr(...) abort
  if has_key(l:self.handlers, 'on_stderr')
    call l:self.handlers['on_stderr'](a:)
  end
endfunction

function! s:term.on_exit(...) abort
  if has_key(l:self.handlers, 'on_exit')
    call l:self.handlers['on_exit'](a:)
  end
  call neoterm#destroy(l:self)
endfunction
