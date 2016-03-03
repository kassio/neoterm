aug neoterm_test_elixir
  au VimEnter,BufRead,BufNewFile *_test.exs call neoterm#test#libs#add('elixir')
  au VimEnter *
        \ if filereadable('test/test_helper.exs') |
        \   call neoterm#test#libs#add('elixir') |
        \ endif
aug END
