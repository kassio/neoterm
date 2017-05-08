# neoterm

Use the same terminal for everything. The main reason for this plugin is reuse
the terminal easily. All commands opens a terminal if it's not open or reuse the
open terminal.
REPL commands, opens a terminal and the proper REPL, if it's not opened.

- NeoVim terminal helper functions/commands.
- Wraps some REPL to receive current line or selection.
- Many terminals support:
  - ![many-terms](https://cloud.githubusercontent.com/assets/120483/8921869/fe459572-34b1-11e5-93c9-c3b6f3b44719.gif)


## test libs (removed on 05/Feb/2017)

*This feature was removed on 05/Feb/2017, please consider to use the
vim-test with `neoterm` strategy to replace this feature*

- [Related issue](https://github.com/kassio/neoterm/issues/123).

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
* Haskell: `ghci`
* Idris: `idris`
* GNU Octave: `octave`
  * For Octave 4.0.0 and later, you can enable Qt widgets (dialogs, plots, etc.) using `g:neoterm_repl_octave_qt = 1`
* MATLAB: `matlab -nodesktop -nosplash`
* PARI/GP: `gp`
* PHP: `psysh` and `php`

### Troubleshooting

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

Open a pull request, repls and other features to this plugin. :smiley:

## example config file:

```viml
let g:neoterm_position = 'horizontal'
let g:neoterm_automap_keys = ',tt'

nnoremap <silent> <f10> :TREPLSendFile<cr>
nnoremap <silent> <f9> :TREPLSendLine<cr>
vnoremap <silent> <f9> :TREPLSendSelection<cr>

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
