# neoterm

Use the same terminal for everything. The main reason for this plugin is reuse
the terminal easily. All commands opens a terminal if it's not open or reuse the
open terminal.
REPL commands, opens a terminal and the proper REPL, if it's not opened.

- NeoVim terminal helper functions/commands.
- Wraps some test libs to run easilly within NeoVim terminal.
- Wraps some REPL to receive current line or selection.

## test libs

Run test libs with 3 different scopes:

* all (`neoterm#test_runner('all')`):

Run all tests from the current project. For a Rails project with rspec, it's the
command: `rspec`.

* file (`neoterm#test_runner('file')`):

Run the current test file. For a Rails project with rspec, it's the command:
`rspec spec/path/to/file_spec.rb`.

* current (`neoterm#test_runner('current')`):

Run the nearst test in the current test file. For a Rails project with rspec,
it's the command: `rspec spec/path/to/file_spec.rb:123`.

### test libs supported

* rspec
* minitest

## REPL

* `neoterm#repl#line()`: sends the current line to a REPL in a terminal.
* `neoterm#repl#selection()`: sends the current selection to a REPL in a terminal.

### REPL supported

* `irb`
* `bundle exec rails console`

## other useful commands:

* `:T <command>`: Opens a terminal, or use an opened terminal, and runs the
                  given command within a terminal.
* `:Tmap <command>`: maps a the given command to ,tt.

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
  let command = 'rspec'

  if a:scope == 'file'
    let command .= ' ' . expand('%:p')
  elseif a:scope == 'current'
    let command .= ' ' . expand('%:p') . ':' . line('.')
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
let g:neoterm_clear_cmd = "clear; printf '=%.0s' {1..80}; clear"
let g:neoterm_position = 'vertical'
let g:neoterm_automap_keys = ',tt'

nnoremap <silent> <f9> :call neoterm#repl#line()<cr>
vnoremap <silent> <f9> :call neoterm#repl#selection()<cr>

" run set test lib
nnoremap <silent> ,rt :call neoterm#test#run('all')<cr>
nnoremap <silent> ,rf :call neoterm#test#run('file')<cr>
nnoremap <silent> ,rn :call neoterm#test#run('current')<cr>
nnoremap <silent> ,rr :call neoterm#test#rerun()<cr>

" Useful maps
" closes the all terminal buffers
nnoremap <silent> ,tc :call neoterm#close_all()<cr>
" clear terminal
nnoremap <silent> ,tl :call neoterm#clear()<cr>
```
