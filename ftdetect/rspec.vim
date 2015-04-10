aug neoterm_test_rspec
  au VimEnter,BufRead,BufNewFile *_spec.rb,*_feature.rb call neoterm#test#libs#add('rspec')
  au VimEnter *
        \ if filereadable('spec/spec_helper.rb') |
        \   call neoterm#test#libs#add('rspec') |
        \ endif
aug END
