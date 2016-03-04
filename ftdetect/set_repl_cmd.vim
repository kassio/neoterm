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
        \ endif
  " Python
  au VimEnter,BufRead,BufNewFile *.py,
        \ if executable('ipython') |
        \   call neoterm#repl#set('ipython') |
        \ elseif executable('python') |
        \   call neoterm#repl#set('python') |
        \ end
  " JavaScript
  au BufEnter *
        \ if &filetype == 'javascript' && executable('node') |
        \   call neoterm#repl#set('node') |
        \ end
  " Elixir
  au VimEnter,BufRead,BufNewFile *
        \ if filereadable('config/config.exs') |
        \   call neoterm#repl#set('iex -S mix') |
        \ elseif &filetype == 'elixir' |
        \   call neoterm#repl#set('iex') |
        \ endif
  " Julia
  au VimEnter,BufRead,BufNewFile *.jl,
        \ if executable('julia') |
        \   call neoterm#repl#set('julia') |
        \ end
aug END
