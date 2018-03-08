function! neoterm#term#vim#()
  return s:vim
endfunction

let s:vim = {}

function! s:vim.new(opts)
  let l:opts = {
        \ 'curwin': 1,
        \ 'term_finish': 'close',
        \ 'term_name': a:opts.name,
        \ 'out_cb': get(a:opts.handlers, 'on_stdout'),
        \ 'err_cb': get(a:opts.handlers, 'on_stderr'),
        \ 'exit_cb': get(a:opts.handlers, 'on_exit')
        \ }
  if g:neoterm_direct_open_repl
    return term_start(g:neoterm_repl_command, l:opts)
  else
    return term_start(g:neoterm_shell, l:opts)
  end
endfunction

function! s:vim.termsend(termid, cmd)
  let l:cmd = type(a:cmd) ==# type("") ? a:cmd : join(a:cmd, "\<CR>")
  return term_sendkeys(a:termid, l:cmd)
endfunction
