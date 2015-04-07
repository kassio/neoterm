aug terminal_setup
  au TermOpen * let g:neoterm_current_id = b:terminal_job_id
  au TermOpen * setlocal nonumber norelativenumber
  au BufUnload term://*
        \ if exists('g:neoterm_current_id') |
        \   unlet g:neoterm_current_id |
        \ endif
  au BufUnload term://*
        \ if exists('g:neoterm_repl_loaded') |
        \   unlet g:neoterm_repl_loaded |
        \ endif

  " rspec
  au VimEnter,BufRead,BufNewFile *_spec.rb,*_feature.rb let g:neoterm_test_lib = 'rspec'
  au VimEnter *
        \ if filereadable('spec/spec_helper.rb') |
        \   let g:neoterm_test_lib = 'rspec' |
        \ endif

  " minitest
  au VimEnter,BufRead,BufNewFile *_test.rb let g:neoterm_test_lib = 'minitest'
  au VimEnter *
        \ if filereadable('test/test_helper.rb') |
        \   let g:neoterm_test_lib = 'minitest' |
        \ endif

  " Ruby REPL
  au VimEnter,BufRead,BufNewFile *
        \ if filereadable('config/application.rb') |
        \   let g:neoterm_repl_command = 'bundle exec rails console' |
        \ elseif &ft == 'ruby' |
        \   let g:neoterm_repl_command = 'irb' |
        \ endif
aug END

let g:neoterm_last_test_command = ''

if !exists('g:neoterm_clear_cmd')
  let g:neoterm_clear_cmd = 'clear'
end

if !exists('g:neoterm_position')
  let g:neoterm_position = 'horizontal'
end

command! -nargs=? TTestLib let g:neoterm_test_lib=<q-args>
command! -nargs=1 Tpos let g:neoterm_position=<q-args>

command! -nargs=+ T call neoterm#do(<q-args>)
command! -nargs=+ Tmap exec "nnoremap <silent> ,tt :T " . <q-args> . "<cr>"

command! -nargs=+ HT call neoterm#horizontal_term(<q-args>)
command! -nargs=+ HTmap exec "nnoremap <silent> ,tt :HT " . <q-args> . "<cr>"

command! -nargs=+ VT call neoterm#vertical_term(<q-args>)
command! -nargs=+ VTmap exec "nnoremap <silent> ,tt :VT " . <q-args> . "<cr>"

command! -range=% REPLSendSelection call neoterm#repl(text#get_visual_lines())
command! REPLSendLine call neoterm#repl([getline('.')])
