aug neoterm_test_cucumber
  au VimEnter,BufRead,BufNewFile *.feature call neoterm#test#libs#add('cucumber')
aug END
