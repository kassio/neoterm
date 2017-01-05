aug neoterm_test_minitest
  au VimEnter,BufRead,BufNewFile *_test.rb
        \ if get(g:neoterm_test_lib_primary, 'ruby') == 'minitest' |
        \   call neoterm#test#libs#add('minitest') |
        \ endif
  au VimEnter *
        \ if filereadable('test/test_helper.rb') && get(g:neoterm_test_lib_primary, 'ruby') == 'minitest' |
        \   call neoterm#test#libs#add('minitest') |
        \ endif
aug END
