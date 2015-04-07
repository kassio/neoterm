let g:neoterm_last_test_command = ''

if !exists('g:neoterm_clear_cmd')
  let g:neoterm_clear_cmd = 'clear'
end

if !exists('g:neoterm_position')
  let g:neoterm_position = 'horizontal'
end

if !exists('g:neoterm_automap_keys')
  let g:neoterm_automap_keys = ',tt'
end

aug neoterm_setup
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

command! -nargs=? TTestLib let g:neoterm_test_lib=<q-args>
command! -nargs=1 Tpos let g:neoterm_position=<q-args>

command! -nargs=+ T call neoterm#do(<q-args>)
command! -nargs=+ Tmap exec "nnoremap <silent> "
      \ . g:neoterm_automap_keys .
      \ " :T " . <q-args> . "<cr>"
