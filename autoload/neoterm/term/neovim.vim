function! neoterm#term#neovim#()
  return s:neovim
endfunction

let s:neovim = {}

function! s:neovim.new(opts)
  if g:neoterm_direct_open_repl
    return termopen(g:neoterm_repl_command, a:opts)
  else
    if g:neoterm_marker ==# ''
      let l:neoterm_marked_shell = g:neoterm_shell
    else
      let l:neoterm_marked_shell =
            \ printf('%s%s-%s', g:neoterm_shell, g:neoterm_marker, a:opts.id)
    end

    return termopen(l:neoterm_marked_shell, a:opts)
  end
endfunction

function! s:neovim.termsend(termid, command)
  return chansend(a:termid, a:command)
endfunction

function! s:neovim.get_current_termid()
  return b:terminal_job_id
endfunction
