if !has("nvim") || get(g:, 'neoterm_loaded', 0)
  finish
endif

let g:neoterm_loaded = 1

let g:neoterm = {
      \ "last_id": 0,
      \ "open": 0,
      \ "instances": {}
      \ }

function! g:neoterm.next_id()
  let self.last_id += 1
  return self.last_id
endfunction

function! g:neoterm.has_any()
  return len(self.instances) > 0 && self.last_id > 0
endfunction

function! g:neoterm.last()
  if self.has_any()
    return self.instances[self.last_id]
  end
endfunction

let g:neoterm_statusline = ""

if !exists("g:neoterm_shell")
  if exists('&shellcmdflag')
    let g:neoterm_shell = &shell . ' ' . substitute(&shellcmdflag, '[-/]c', '', '')
  else
    let g:neoterm_shell = &shell
  end
end

if !exists("g:neoterm_size")
  let g:neoterm_size = ""
end

if !exists("g:neoterm_test_libs")
  let g:neoterm_test_libs = []
end

if !exists("g:neoterm_position")
  let g:neoterm_position = "horizontal"
end

if !exists("g:neoterm_automap_keys")
  let g:neoterm_automap_keys = ",tt"
end

if !exists("g:neoterm_keep_term_open")
  let g:neoterm_keep_term_open = 1
end

if !exists("g:neoterm_autoinsert")
  let g:neoterm_autoinsert = 0
end

if !exists("g:neoterm_split_on_tnew")
  let g:neoterm_split_on_tnew = 1
end

if !exists("g:neoterm_run_tests_bg")
  let g:neoterm_run_tests_bg = 0
end

if !exists("g:neoterm_raise_when_tests_fail")
  let g:neoterm_raise_when_tests_fail = 0
end

if !exists("g:neoterm_focus_when_tests_fail")
  let g:neoterm_focus_when_tests_fail = 0
end

if !exists("g:neoterm_close_when_tests_succeed")
  let g:neoterm_close_when_tests_succeed = 0
end

if !exists("g:neoterm_test_status_format")
  let g:neoterm_test_status_format = "[%s]"
end

if !exists("g:neoterm_test_status")
  let g:neoterm_test_status = {
        \ "running": "RUNNING",
        \ "success": "SUCCESS",
        \ "failed": "FAILED"
        \ }
end

if !exists("g:neoterm_use_relative_path")
  let g:neoterm_use_relative_path = 0
end

if !exists("g:neoterm_repl_ruby")
  let g:neoterm_repl_ruby = "irb"
end

if !exists("g:neoterm_repl_python")
  let g:neoterm_repl_python = ""
end

if !exists("g:neoterm_repl_octave_qt")
  let g:neoterm_repl_octave_qt = 0
end

if !exists("g:neoterm_repl_php")
  let g:neoterm_repl_php = ""
end

if !exists("g:neoterm_eof")
  let g:neoterm_eof = ""
end

hi! NeotermTestRunning ctermfg=11 ctermbg=0
hi! NeotermTestSuccess ctermfg=2 ctermbg=0
hi! NeotermTestFailed ctermfg=1 ctermbg=0

aug neoterm_setup
  au!
  au TermOpen term://*neoterm* setlocal nonumber norelativenumber
aug END

command! -bar -complete=shellcmd Tnew silent call neoterm#tnew()
command! -bar -complete=shellcmd Topen silent call neoterm#open()
command! -bar -complete=shellcmd Tclose silent call neoterm#close()
command! -bar -complete=shellcmd Ttoggle silent call neoterm#toggle()
command! -bar -complete=shellcmd -nargs=+ T silent call neoterm#do(<q-args>)
command! -complete=shellcmd -nargs=+ Tmap silent call neoterm#map_for(<q-args>)
command! -nargs=1 Tpos let g:neoterm_position=<q-args>

" REPL
command! -bar -complete=customlist,neoterm#list -nargs=1 TREPLSetTerm silent call neoterm#repl#term(<q-args>)
command! -range=% TREPLSendFile silent call neoterm#repl#line(<line1>, <line2>)
command! -range TREPLSendSelection silent call neoterm#repl#selection()
command! -range TREPLSendLine silent call neoterm#repl#line(<line1>, <line2>)

" Test
command! -complete=customlist,neoterm#list -nargs=1 TTestSetTerm silent call neoterm#test#term(<q-args>)
command! -complete=customlist,neoterm#test#libs#autocomplete -nargs=? TTestLib silent call neoterm#test#libs#add(<q-args>)
command! TTestClearStatus silent let g:neoterm_statusline=""
