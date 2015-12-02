aug neoterm_test_npm
  au VimEnter,BufRead,BufNewFile *.js call neoterm#test#libs#add('npm')
aug END
