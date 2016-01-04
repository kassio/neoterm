aug set_repl_cmd
  au!
  " Ruby
  au VimEnter,BufRead,BufNewFile *.rb,*.erb,Rakefile
        \ if executable('pry') |
        \   call neoterm#repl#set('pry') |
        \ elseif executable('irb') |
        \   call neoterm#repl#set('irb') |
        \ end
  " Rails
  au VimEnter,BufRead,BufNewFile *
        \ if filereadable('config/application.rb') |
        \   call neoterm#repl#set('bundle exec rails console') |
        \ else |
        \   call neoterm#repl#set('') |
        \ endif
  " Python
  au VimEnter,BufRead,BufNewFile *.py,
        \ if executable('ipython') |
        \   call neoterm#repl#set('ipython') |
        \ elseif executable('python') |
        \   call neoterm#repl#set('python') |
        \ end
  " JavaScript
  au VimEnter,BufRead,BufNewFile *.js,
        \ if executable('node') |
        \   call neoterm#repl#set('node') |
        \ end
aug END
