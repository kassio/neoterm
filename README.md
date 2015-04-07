# neoterm

- NeoVim terminal helper functions/commands.
- Wraps some test libs to run easilly within NeoVim terminal.
- Wraps some REPL to receive current line or selection.

## Test libs

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

### Test libs supported

* minitest
* rspec

## REPL

* `:REPLSendLine`: sends the current line to a REPL in a terminal.
* `:REPLSendSelection`: sends the current selection to a REPL in a terminal.

### REPL supported

* `irb`
* `bundle exec rails console`

## Other useful commands:

* `:T <command>`: runs the given command within a terminal.
* `:Tmap <command>`: maps a the given command to ,tt.

## Example config file:

```viml
let g:neoterm_clear_cmd = "clear; printf '=%.0s' {1..80}; clear"
let g:neoterm_position = 'vertical'
let g:neoterm_last_test_command = ''

nnoremap <silent> <f9> :REPLSendLine<cr>
vnoremap <silent> <f9> :REPLSendSelection<cr>

" run set test lib
nnoremap <silent> ,rt :call neoterm#test_runner('all')<cr>
nnoremap <silent> ,rf :call neoterm#test_runner('file')<cr>
nnoremap <silent> ,rn :call neoterm#test_runner('current')<cr>
nnoremap <silent> ,rr :call neoterm#test_rerun()<cr>

" Useful maps
" closes the current terminal
nnoremap <silent> ,tc :bd! term://*<cr>
" clear terminal
nnoremap <silent> ,tl :exec "T " . g:neoterm_clear_cmd<cr>
```
