aug neoterm_test_golang
  au VimEnter,BufRead,BufNewFile *.go, call neoterm#test#libs#add('golang')
aug END
