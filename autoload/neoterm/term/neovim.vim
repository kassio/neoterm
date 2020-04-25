function! neoterm#term#neovim#() abort
  return s:neovim
endfunction

let s:neovim = {}

function! s:neovim.new(opts) abort
  if g:neoterm_direct_open_repl && len(g:neoterm_repl_command) < 2
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

function! s:neovim.termsend(termid, command) abort
  return chansend(a:termid, a:command)
endfunction

function! s:neovim.get_current_termid() abort
  return b:terminal_job_id
endfunction
