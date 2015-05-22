let g:neoterm_last_test_command = ''

if !exists('g:neoterm_size')
  let g:neoterm_size = ''
end

if !exists('g:neoterm_test_libs')
  let g:neoterm_test_libs = []
end

if !exists('g:neoterm_clear_cmd')
  let g:neoterm_clear_cmd = 'clear'
end

if !exists('g:neoterm_position')
  let g:neoterm_position = 'horizontal'
end

if !exists('g:neoterm_automap_keys')
  let g:neoterm_automap_keys = ',tt'
end

if !exists('g:neoterm_keep_term_open')
  let g:neoterm_keep_term_open = 1
end

aug neoterm_setup
  au TermOpen * let g:neoterm_terminal_jid = b:terminal_job_id
  au TermOpen * let g:neoterm_buffer_id = bufnr('%')
  au TermOpen * setlocal nonumber norelativenumber
  au BufUnload term://*
        \ if exists('g:neoterm_terminal_jid') |
        \   unlet g:neoterm_terminal_jid |
        \   unlet g:neoterm_buffer_id |
        \ endif
  au BufUnload term://*
        \ if exists('g:neoterm_repl_loaded') |
        \   unlet g:neoterm_repl_loaded |
        \ endif
aug END

command! -complete=customlist,neoterm#test#libs#autocomplete -nargs=? TTestLib call neoterm#test#libs#add(<q-args>)
command! -nargs=1 Tpos let g:neoterm_position=<q-args>

command! -complete=shellcmd -nargs=+ T call neoterm#do(<q-args>)
command! -complete=shellcmd -nargs=+ Tmap exec "nnoremap <silent> "
      \ . g:neoterm_automap_keys .
      \ " :T " . neoterm#expand_cmd(<q-args>) . "<cr>"
