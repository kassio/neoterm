function! neoterm#term#neovim#()
  return s:neovim
endfunction

let s:neovim = {}

function! s:neovim.new(opts)
  if g:neoterm_direct_open_repl
    return termopen(g:neoterm_repl_command, a:opts)
  else
    return termopen(g:neoterm_shell, a:opts)
  end
endfunction

function! s:neovim.termsend(termid, command)
  return jobsend(a:termid, a:command)
endfunction
