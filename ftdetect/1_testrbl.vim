aug neoterm_test_minitest
  au VimEnter,BufRead,BufNewFile *_test.rb
        \ if g:neoterm_test_lib_primary == 'testrbl' |
        \   call neoterm#test#libs#add('testrbl') |
        \ endif
  au VimEnter *
        \ if filereadable('test/test_helper.rb') && g:neoterm_test_lib_primary == 'testrbl' |
        \   call neoterm#test#libs#add('testrbl') |
        \ endif
aug END
