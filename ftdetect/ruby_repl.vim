aug neoterm_ruby_repl
  au VimEnter,BufRead,BufNewFile *
        \ if filereadable('config/application.rb') |
        \   let g:neoterm_repl_command = 'bundle exec rails console' |
        \ elseif executable('pry') |
        \   let g:neoterm_repl_command = 'pry' |
        \ elseif executable('irb') |
        \   let g:neoterm_repl_command = 'irb' |
        \ endif
aug END
