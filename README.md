# neoterm

[![lint](https://github.com/kassio/neoterm/workflows/lint/badge.svg?branch=master)](https://github.com/kassio/neoterm/actions?query=workflow%3Alint)
[![tests](https://github.com/kassio/neoterm/workflows/tests/badge.svg?branch=master)](https://github.com/kassio/neoterm/actions?query=workflow%3Atests)
[![license](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

 ```
 __   _ _______  _____  _______ _______  ______ _______
 | \  | |______ |     |    |    |______ |_____/ |  |  |
 |  \_| |______ |_____|    |    |______ |    \_ |  |  |
```


Use the same terminal for everything. The main reason for this plugin is to
reuse the terminal easily. All commands open a terminal if one does not already
exist. REPL commands open a terminal and the proper REPL if not already opened.

- Neovim/Vim terminal helper functions/commands.
- Wraps REPLs to receive current file, line or selection.
- Multiple terminal support:
  - ![many-terms](https://cloud.githubusercontent.com/assets/120483/8921869/fe459572-34b1-11e5-93c9-c3b6f3b44719.gif)

## Installation

### Vundle/Plug.vim/minpac/any other

You can install this plugin using any vim plugin manager by using the path on
GitHub for this repository:

```viml
[Plugin|Plug|...] 'kassio/neoterm'
```

See the your plugin manager documentation for more information.

### Manual

For installation without a package manager, you can clone this Git repository
into a bundle directory as with pathogen, and add the repository to your
runtime path yourself. First clone the repository:

```console
cd ~/.vim/bundle
git clone https://github.com/kassio/neoterm.git
```

Then, modify your `~/.vimrc` file to add this plugin to your runtime path:

```viml
set nocompatible
filetype off

let &runtimepath.=',~/.vim/bundle/neoterm'

filetype plugin on
```

You can add the following line to generate documentation tags automatically,
if you don't have something similar already, so you can use the `:help` command
to consult neoterm's online documentation:

```viml
silent! helptags ALL
```

### Windows OS

For Windows users, replace usage of the Unix `~/.vim` directory with
`%USERPROFILE%\_vim`, or another directory if you have configured
Vim differently. On Windows, your `~/.vimrc` file will be similarly
stored in `%USERPROFILE%\_vimrc`.

## Default behaviour

Neoterm's default behavior is to create a new buffer on the current window when
opening a neoterm. You can change this with `g:neoterm_default_mod`. Check the
[documentation](https://github.com/kassio/neoterm/blob/master/doc/neoterm.txt)
for more information.

## Send commands to a neoterm window

* `:T {command}`: Opens a terminal, or use an opened terminal, and runs the
                  given command within a terminal.
* `:Tmap {command}`: maps a given command to `g:neoterm_automap_keys`.

## Multiple neoterm windows commands

* `:3T {command}`: Will send the command to `neoterm-3`.

### useful mappings:

I like to set some mappings to make me more productive.

```viml
" 3<leader>tl will clear neoterm-3.
nnoremap <leader>tl :<c-u>exec v:count.'Tclear'<cr>
```

## test libs (removed on 05/Feb/2017)

*This feature was removed on 05/Feb/2017, please consider using vim-test with
`neoterm` strategy to replace this feature.*

- [Related issue](https://github.com/kassio/neoterm/issues/123).

## REPL

* `TREPLSendFile`: sends the current file to a REPL in a terminal.
* `TREPLSendLine`: sends the current line to a REPL in a terminal.
* `TREPLSendSelection`: sends the selection to a REPL in a terminal.
* `<Plug>(neoterm-repl-send)`: sends with text-objects or motions, or sends the
  selection to a REPL in a terminal.
* `<Plug>(neoterm-repl-send-line)`: sends the current line to a REPL in a
  terminal.

### Supported REPLs

* Clojure: `lein repl`
* Elixir: `iex` and `iex -S mix` (if `config/config.exs` exists)
* GNU Octave: `octave`
  * For Octave 4.0.0 and later, you can enable Qt widgets (dialogs, plots, etc.)
    using `g:neoterm_repl_octave_qt = 1`
* Haskell: `ghci`
* Idris: `idris`
* Janet: `janet`
* JavaScript: `node`
* Java: `java`
* Julia: `julia`
* LFE: `lfe`
* Lua with `lua` and `luap`.
* MATLAB: `matlab -nodesktop -nosplash`
* PARI/GP: `gp`
* PHP: `g:neoterm_repl_php` and `psysh` and `php`
* Python: `ipython`, `jupyter console` and `python`
* R / R Markdown: `R`
* Racket: `racket`
* Rails: `bundle exec rails console`
* Ruby: `pry` and `irb`
* Rust: `evcxr`
* SML: `rlwrap sml` or `sml`
* Scala: `sbt console`
* Stata: `stata -q`
* TCL: `tclsh`

### Troubleshooting

Most standard file extensions for the above REPLs are picked up by Neovim/Vim's
default filetype plugins. However, there are some exceptions:
* Julia `.jl` files, which are detected as `filetipe=lisp`
* Idris `.idr`, `.lidr` files which are not recognised as any filetype
* LFE `.lfe` files, which are not recognized as any filetype

To fix this, either install a suitable plugin for the language or add something like
the following to your `init.vim`:
```viml
au VimEnter,BufRead,BufNewFile *.jl set filetype=julia
au VimEnter,BufRead,BufNewFile *.idr set filetype=idris
au VimEnter,BufRead,BufNewFile *.lidr set filetype=lidris
au VimEnter,BufRead,BufNewFile *.lfe set filetype=lfe
```

If you want to use the jupyter console REPL present on your path, you can use
this configuration in your `init.vim`:
```viml
function! Chomp(string)
    return substitute(a:string, '\n\+$', '', '')
endfunction
let g:neoterm_repl_python = Chomp(system('which jupyter')) . ' console'
```

Note that the same approach may be used to use Jupyter for R or Stata, provided the appropriate kernels ([IRkernel](https://github.com/IRkernel/IRkernel) and [stata_kernel](https://kylebarron.dev/stata_kernel/)) are installed.

## [Contributing](CONTRIBUTING.md)
## [Changelog](CHANGELOG.md)
## [Documentation](doc/neoterm.txt)
