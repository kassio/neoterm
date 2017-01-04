aug neoterm_test_minitest
  au VimEnter,BufRead,BufNewFile *_test.rb
        \ if g:neoterm_test_lib_primary == 'minitest' |
        \   call neoterm#test#libs#add('minitest') |
        \ endif
  au VimEnter *
        \ if filereadable('test/test_helper.rb') && g:neoterm_test_lib_primary == 'minitest' |
        \   call neoterm#test#libs#add('minitest') |
        \ endif
aug END
