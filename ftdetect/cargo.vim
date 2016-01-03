aug neoterm_test_cargo
  au VimEnter,BufRead,BufNewFile *.rs, call neoterm#test#libs#add('cargo')
aug END
