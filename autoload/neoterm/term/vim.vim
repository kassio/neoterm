function! neoterm#term#vim#() abort
  return s:vim
endfunction

let s:vim = {}

function! s:vim.new(opts) abort
  let l:opts = {
        \ 'curwin': 1,
        \ 'term_finish': 'close',
        \ 'term_name': a:opts.name,
        \ 'out_cb': a:opts.on_stdout,
        \ 'err_cb': a:opts.on_stderr,
        \ 'close_cb': a:opts.on_exit,
        \ 'exit_cb': a:opts.on_exit
        \ }

  return term_start(a:opts.shell, l:opts)
endfunction

function! s:vim.termsend(termid, command) abort
  let l:command = type(a:command) ==# type('') ? a:command : join(a:command, "\<CR>")
  return term_sendkeys(a:termid, l:command)
endfunction

function! s:vim.get_current_termid() abort
  return bufnr('')
endfunction
