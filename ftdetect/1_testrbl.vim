aug neoterm_test_minitest
  au VimEnter,BufRead,BufNewFile *_test.rb
        \ call neoterm#test#libs#add('testrbl')
  au VimEnter *
        \ if filereadable('test/test_helper.rb') |
        \   call neoterm#test#libs#add('testrbl') |
        \ endif
aug END
