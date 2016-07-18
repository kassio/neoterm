aug neoterm_test_crystal
  au VimEnter,BufRead,BufNewFile *.cr, call neoterm#test#libs#add('crystal')
aug END
