# neoterm

Use the same terminal for everything. The main reason for this plugin is reuse
the terminal easily. All commands opens a terminal if it's not open or reuse the
open terminal.
REPL commands, opens a terminal and the proper REPL, if it's not opened.

- NeoVim terminal helper functions/commands.
- Wraps some test libs to run easilly within NeoVim terminal.
  - Running, Success, Failed: status on statusline supported (matching the test result #25):
  - ![test-status-line](https://cloud.githubusercontent.com/assets/120483/8212291/425189d2-14f1-11e5-8059-822eda0b702c.gif)
- Wraps some REPL to receive current line or selection.
- Many terminals support:
  - ![many-terms](https://cloud.githubusercontent.com/assets/120483/8921869/fe459572-34b1-11e5-93c9-c3b6f3b44719.gif)


## test libs

Run test libs with 3 different scopes:

* all (`neoterm#test#run('all')`):

Run all tests from the current project. For a Rails project with rspec, it's the
command: `rspec`.

* file (`neoterm#test#run('file')`):

Run the current test file. For a Rails project with rspec, it's the command:
`rspec spec/path/to/file_spec.rb`.

* current (`neoterm#test#run('current')`):

Run the nearst test in the current test file. For a Rails project with rspec,
it's the command: `rspec spec/path/to/file_spec.rb:123`.

### test libs supported

* rspec
  * You can override the default command (`bundle exec rspec`) using the
    `g:neoterm_rspec_lib_cmd`
  * Status in statusline supported
* cucumber
  * You can override the default command (`bundle exec cucumber`) using the
    `g:neoterm_cucumber_lib_cmd`
* minitest
  * Status in statusline supported
* go-lang test ([partially implemented](https://github.com/kassio/neoterm/pull/8))
* nose ([partially implemented](https://github.com/kassio/neoterm/pull/9))
* Cargo ([partially implemented](https://github.com/kassio/neoterm/pull/59))
* npm
  * You can override the default command (`npm test`) using the
    `g:neoterm_npm_lib_cmd`
* elixir

## REPL

* `TREPLSend`: sends the current line or the selection to a REPL in a terminal.
* `TREPLSendFile`: sends the current file to a REPL in a terminal.

### REPLs supported

* Ruby: `pry` and `irb`
* Rails: `bundle exec rails console`
* Python: `ipython` and `python`
* JavaScript: `node`
* Elixir: `iex`
* Julia: `julia`
* R / R Markdown: `R`
* Idris: `idris`
* PARI/GP: `gp`

The REPL is set using the filetype plugin so make sure to set
```viml
filetype plugin on
```

Most standard file extensions for the above REPLs are picked up by Neovim's default
filetype plugins. However, there are two exceptions:
* Julia `.jl` files, which are detected as `filetipe=lisp`
* Idris `.idr`, `.lidr` files which are not recognised as any filetype
To fix this, either install a suitable plugin for the language or add something like
the following to your `init.vim`:
```viml
au VimEnter,BufRead,BufNewFile *.jl set filetype=julia
au VimEnter,BufRead,BufNewFile *.idr set filetype=idris
au VimEnter,BufRead,BufNewFile *.lidr set filetype=lidris
```

## other useful commands:

* `:T <command>`: Opens a terminal, or use an opened terminal, and runs the
                  given command within a terminal.
* `:Tmap <command>`: maps a the given command to `,tt`.

## Contributing

Open a pull request, I'll be glad in review/add new test libs, repls and other
features to this plugin. :smiley:

### how add a new test lib

A test lib is defined by a function and an autocommand group.

```console
.nvim/plugged/neoterm/
▾ autoload/
  ▾ neoterm/
    ▾ test/
        rspec.vim
▾ ftdetect/
    rspec.vim
```

The function (`neoterm#test#<lib_name>#run`) will return the command, by the
given scope, that will be runned in a terminal window. This function should be
defined in its own file: `/autoload/neoterm/test/<lib_name>.vim`.

* autoload/neoterm/test/rspec.vim
```viml
function! neoterm#test#rspec#run(scope)
  let path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')
  let command = 'rspec'

  if a:scope == 'file'
    let command .= ' ' . path
  elseif a:scope == 'current'
    let command .= ' ' . path . ':' . line('.')
  endif

  return command
endfunction
```

The autocommand group will detect when the lib should be available. For example,
the rspec is available when exists a file `spec/spec_helper.rb` on the current
folder, or when a file that matches with `*_spec.rb` or `*_feature.rb` is
opened.

* ftdetect/rspec.vim
```viml
aug neoterm_test_rspec
  au VimEnter,BufRead,BufNewFile *_spec.rb,*_feature.rb call neoterm#test#libs#add('rspec')
  au VimEnter *
        \ if filereadable('spec/spec_helper.rb') |
        \   call neoterm#test#libs#add('rspec') |
        \ endif
aug END
```

## example config file:

```viml
let g:neoterm_position = 'horizontal'
let g:neoterm_automap_keys = ',tt'

nnoremap <silent> <f10> :TREPLSendFile<cr>
nnoremap <silent> <f9> :TREPLSend<cr>
vnoremap <silent> <f9> :TREPLSend<cr>

" run set test lib
nnoremap <silent> ,rt :call neoterm#test#run('all')<cr>
nnoremap <silent> ,rf :call neoterm#test#run('file')<cr>
nnoremap <silent> ,rn :call neoterm#test#run('current')<cr>
nnoremap <silent> ,rr :call neoterm#test#rerun()<cr>

" Useful maps
" hide/close terminal
nnoremap <silent> ,th :call neoterm#close()<cr>
" clear terminal
nnoremap <silent> ,tl :call neoterm#clear()<cr>
" kills the current job (send a <c-c>)
nnoremap <silent> ,tc :call neoterm#kill()<cr>

" Rails commands
command! Troutes :T rake routes
command! -nargs=+ Troute :T rake routes | grep <args>
command! Tmigrate :T rake db:migrate

" Git commands
command! -nargs=+ Tg :T git <args>
```
