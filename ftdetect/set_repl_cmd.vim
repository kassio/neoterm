if has('nvim') || has('terminal')
  aug set_repl_cmd
    au!
    " Ruby and Rails
    au FileType ruby,eruby
          \ if executable('bundle') && filereadable('config/application.rb') |
          \   call neoterm#repl#set('bundle exec rails console') |
          \ elseif executable(g:neoterm_repl_ruby) |
          \   call neoterm#repl#set(g:neoterm_repl_ruby) |
          \ end
    " Python
    au FileType python
          \ let s:argList = split(g:neoterm_repl_python) |
          \ if len(s:argList) > 0 && executable(s:argList[0]) |
          \   call neoterm#repl#set(g:neoterm_repl_python) |
          \ elseif executable('ipython') |
          \   call neoterm#repl#set('ipython --no-autoindent') |
          \ elseif executable('python') |
          \   call neoterm#repl#set('python') |
          \ end
    " JavaScript
    au FileType javascript
          \ if executable('node') |
          \   call neoterm#repl#set('node') |
          \ end
    " Elixir
    au FileType elixir
          \ if filereadable('config/config.exs') |
          \   call neoterm#repl#set('iex -S mix') |
          \ elseif &filetype == 'elixir' |
          \   call neoterm#repl#set('iex') |
          \ end
    " Julia
    au FileType julia
          \ if executable('julia') |
          \   call neoterm#repl#set('julia') |
          \ end
    " PARI/GP
    au FileType gp
          \ if executable('gp') |
          \   call neoterm#repl#set('gp') |
          \ end
    " R
    au FileType r,rmd
          \ if executable('R') |
          \   call neoterm#repl#set('R') |
          \ end
    " Octave
    au FileType octave
          \ if executable('octave') |
          \   if executable('octave-cli') |
          \     if g:neoterm_repl_octave_qt |
          \       call neoterm#repl#set('octave --no-gui') |
          \     else |
          \       call neoterm#repl#set('octave-cli') |
          \     end |
          \   else |
          \     call neoterm#repl#set('octave') |
          \   end |
          \ end
    " MATLAB
    au FileType matlab
          \ if executable('matlab') |
          \   call neoterm#repl#set('matlab -nodesktop -nosplash') |
          \ end
    " Idris
    au FileType idris,lidris
          \ if executable('idris') |
          \   call neoterm#repl#set('idris') |
          \ end
    " Haskell
    au FileType haskell
          \ if executable('stack') |
          \ call neoterm#repl#set('stack ghci') |
          \ elseif executable('ghci') |
          \   call neoterm#repl#set('ghci') |
          \ end
    au FileType php
          \ let s:argList = split(g:neoterm_repl_php) |
          \ if len(s:argList) > 0 && executable(s:argList[0]) |
          \   call neoterm#repl#set(g:neoterm_repl_php) |
          \ elseif executable('psysh') |
          \   call neoterm#repl#set('psysh') |
          \ elseif executable('php') |
          \   call neoterm#repl#set('php -a') |
          \ end
    " Clojure
    au FileType clojure
          \ if executable('lein') |
          \   call neoterm#repl#set('lein repl') |
          \ end
    " Lua
    au FileType lua
          \ if executable('luap') |
          \   let s:lua_repl='luap' |
          \ elseif executable('lua') |
          \   let s:lua_repl='lua' |
          \ end |
          \ if executable('luarocks') && exists('s:lua_repl') |
          \   call neoterm#repl#set(s:lua_repl . ' -l"luarocks.require"') |
          \ end
    " TCL
    au FileType tcl
          \ if executable('tclsh') |
          \   call neoterm#repl#set('tclsh') |
          \ end
    " Standard ML (SML)
    au FileType sml
          \ if executable('sml') |
          \   if executable('rlwrap') |
          \     call neoterm#repl#set('rlwrap sml') |
          \   else |
          \     call neoterm#repl#set('sml') |
          \   end |
          \ end
    " Scala
    au FileType scala
          \ if executable('sbt') |
          \   call neoterm#repl#set('sbt console') |
          \ end
    " Racket
    au FileType racket
          \ if executable('racket') |
          \   call neoterm#repl#set('racket') |
          \ end
    " Lisp Flavored Erlang
    au FileType lfe
          \ if executable('lfe') |
          \   call neoterm#repl#set('lfe') |
          \ end
  aug END
end
