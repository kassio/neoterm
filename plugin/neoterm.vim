if !has("nvim")
  finish
endif

let g:neoterm_last_test_command = ''
let g:neoterm_statusline = ''

if !exists('g:neoterm_size')
  let g:neoterm_size = ''
end

if !exists('g:neoterm_test_libs')
  let g:neoterm_test_libs = []
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

if !exists('g:neoterm_run_tests_bg')
  let g:neoterm_run_tests_bg = 0
end

if !exists('g:neoterm_raise_when_tests_fail')
  let g:neoterm_raise_when_tests_fail = 0
end

hi! NeotermTestRunning ctermfg=11 ctermbg=0
hi! NeotermTestSuccess ctermfg=2 ctermbg=0
hi! NeotermTestFailure ctermfg=1 ctermbg=0

aug neoterm_setup
  au TermOpen *NEOTERM let g:neoterm_terminal_jid = b:terminal_job_id
  au TermOpen *NEOTERM let g:neoterm_buffer_id = bufnr('%')
  au TermOpen *NEOTERM setlocal nonumber norelativenumber
  au BufUnload,BufDelete,BufWipeout term://*:NEOTERM
        \ unlet! g:neoterm_terminal_jid |
        \ unlet! g:neoterm_buffer_id |
        \ unlet! g:neoterm_repl_loaded |
aug END

command! -range=% TREPLSendFile call neoterm#repl#selection(<line1>, <line2>)
command! -range TREPLSend call neoterm#repl#selection(<line1>, <line2>)
command! -complete=customlist,neoterm#test#libs#autocomplete -nargs=? TTestLib call neoterm#test#libs#add(<q-args>)
command! -nargs=1 Tpos let g:neoterm_position=<q-args>

command! -complete=shellcmd Topen call neoterm#open()
command! -complete=shellcmd Tclose call neoterm#close_all()
command! -complete=shellcmd -nargs=+ T call neoterm#do(<q-args>)
command! -complete=shellcmd -nargs=+ Tmap exec "nnoremap <silent> "
      \ . g:neoterm_automap_keys .
      \ " :T " . neoterm#expand_cmd(<q-args>) . "<cr>"
