aug neoterm_test_nose
  au VimEnter,BufRead,BufNewFile *.py, call neoterm#test#libs#add('nose')
aug END
