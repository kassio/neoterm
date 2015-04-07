# neoterm

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

* minitest
* rspec

## REPL

* `neoterm#repl#line()`: sends the current line to a REPL in a terminal.
* `neoterm#repl#selection()`: sends the current selection to a REPL in a terminal.

### REPL supported

* `irb`
* `bundle exec rails console`

## other useful commands:

* `:T <command>`: runs the given command within a terminal.
* `:Tmap <command>`: maps a the given command to ,tt.

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
" closes the current terminal
nnoremap <silent> ,tc :bd! term://*<cr>
" clear terminal
nnoremap <silent> ,tl :exec "T " . g:neoterm_clear_cmd<cr>
```
