aug neoterm_ruby_repl
  au VimEnter,BufRead,BufNewFile *
        \ if filereadable('config/application.rb') |
        \   let g:neoterm_repl_command = 'bundle exec rails console' |
        \ elseif &ft == 'ruby' |
        \   let g:neoterm_repl_command = 'irb' |
        \ endif
aug END
