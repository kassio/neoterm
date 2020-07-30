function! neoterm#term#neovim#() abort
  return s:neovim
endfunction

let s:neovim = {}

function! s:neovim.new(opts) abort
  return termopen(s:shell(a:opts), a:opts)
endfunction

function! s:neovim.termsend(termid, command) abort
  return chansend(a:termid, a:command)
endfunction

function! s:neovim.get_current_termid() abort
  return b:terminal_job_id
endfunction

function! s:shell(opts)
  if g:neoterm_marker ==# ''
    return a:opts.shell
  else
    return printf('%s%s-%s', a:opts.shell, g:neoterm_marker, a:opts.id)
  end
endfunction
