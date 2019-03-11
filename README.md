# neoterm

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

```vim
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

```vim
set nocompatible
filetype off

let &runtimepath.=',~/.vim/bundle/neoterm'

filetype plugin on
```

You can add the following line to generate documentation tags automatically,
if you don't have something similar already, so you can use the `:help` command
to consult neoterm's online documentation:

```vim
silent! helptags ALL
```

### Windows

For Windows users, replace usage of the Unix `~/.vim` directory with
`%USERPROFILE%\_vim`, or another directory if you have configured
Vim differently. On Windows, your `~/.vimrc` file will be similarly
stored in `%USERPROFILE%\_vimrc`.

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

* Ruby: `pry` and `irb`
* Rails: `bundle exec rails console`
* Python: `ipython` and `python`
* JavaScript: `node`
* Elixir: `iex` and `iex -S mix` (if `config/config.exs` exists)
* Julia: `julia`
* PARI/GP: `gp`
* R / R Markdown: `R`
* GNU Octave: `octave`
  * For Octave 4.0.0 and later, you can enable Qt widgets (dialogs, plots, etc.)
    using `g:neoterm_repl_octave_qt = 1`
* MATLAB: `matlab -nodesktop -nosplash`
* Idris: `idris`
* Haskell: `ghci`
* PHP: `g:neoterm_repl_php` and `psysh` and `php`
* Clojure: `lein repl`
* Lua with `lua` and `luap`.
* TCL: `tclsh`
* SML: `rlwrap sml` or `sml`
* Scala: `sbt console`
* Racket: `racket`
* LFE: `lfe`

### Troubleshooting

Most standard file extensions for the above REPLs are picked up by Neovim/Vim's
default filetype plugins. However, there are two exceptions:
* Julia `.jl` files, which are detected as `filetipe=lisp`
* Idris `.idr`, `.lidr` files which are not recognised as any filetype
* LFE `.lfe` files, which are not recognized as any filetype

To fix this, either install a suitable plugin for the language or add something like
the following to your `init.vim`:
```viml
au VimEnter,BufRead,BufNewFile *.jl set filetype=julia
au VimEnter,BufRead,BufNewFile *.idr set filetype=idris
au VimEnter,BufRead,BufNewFile *.lidr set filetype=lidris
au VimEnter,BufRead,BufNewFile *.lfe, set filetype=lfe
```

## Other useful commands

* `:T {command}`: Opens a terminal, or use an opened terminal, and runs the
                  given command within a terminal.
* `:Tmap {command}`: maps a the given command to `,tt`.

## Dynamic commands

* `:3T {command}`: Will send the command to `neoterm-3`.

## useful mappings:

I like to set some mappings to make me more productive.

```viml
" 3<leader>tl will clear neoterm-3.
nnoremap <leader>tl :<c-u>exec v:count.'Tclear'<cr>
```

## Contributing

Open a pull request to add REPLs and other features to this plugin. :smiley:

## Changelog

* 11/03/2019
  - Make the `signcolumn=auto` in neoterm buffer.
* 29/01/2019
  - Improve `g:neoterm_open_in_all_tabs` documentation.
* 21/12/2018
  - Add `g:neoterm_term_per_tab`, a way to send the commands to the term
    associated to the vim tab.
  - fix `:Topen` without `g:neoterm_default_mod` wasn't re-opening neoterm
    buffer.
* 17/11/2018
  - add `:Tclear!`, this will clear the neoterm buffer scrollback (history)
* 12/11/2018
  - Use `chansend` instead of `jobsend`, which was deprecated.
* 12/11/2018
  - Fix `E119: Not enough arguments for function: <SNR>112_repl_result_handler`
* 09/11/2018
  - Yet another work with '%' expandability.
    - '%' will be expanded to the current file path, respect g:neoterm_use_relative_path;
    - '\%' will be expanded to '%', not the current file path, useful in Windows.
* 20/07/2018
  - `\%` Will not expand the `%`. (Escaping the `%`)
* 03/03/2018
  - **DEPRECATE g:neoterm_split_on_tnew** - `:Tnew` now accepts vim mods (`:help mods`).
  - Introduce `g:neoterm_tnew_mod` to set a default `:Tnew` mod (`:help mods`).
  - Revamp `:Topen`. Now `:[mods][N]Topen` accepts vim mods (`:h mods`) and a
    target, so if one wants to open the neoterm with id 2 in vertical, one can
    do `:vert 2Topen`.
  - Revamp `:Tclose`. Now `:[N]Tclose[!]` accepts a target, so one can close any
    neoterm by its id.
  - Fix a bug with `:[N]Ttoggle` and also make it accepts the neoterm id.
* 04/03/2018
  - Revamp `:[N]Ttoggle`, now it accepts vim mods (`:help mods`) when the toggle
    is opening the neoterm.
  - Revamp `:[N]T`, now it accepts the target, so one can send the command for
    any neoterm by id, like, to send commands to the neoterm 3, one can do
     `:3T ls`.
  - **DEPRECATE T[N], Topen[N], Tclose[N], Tclear[N], Tkill[N]** - The neoterm
    id was moved to the beginning of the command, so instead of `:T2`, for
    example, one must use `:2T`.
* 07/03/2018
  - Do not call `:bdelete!` if buffer does not exist `term#destroy` was calling
    `neoterm#close` which was causing a cyclic call to `:bdelete!
    <neoterm.buffer_id>`.
* 08/03/2018
  - Add vim's terminal support! 🎉🎉🎉
* 15/03/2018
  - Fix bug where `:[N]T` wasn't accepting quoted arguments, like:
    `:T echo "ls"`.
  - Make handlers/callbacks work in vim. Destroy instance when destroying a
    terminal.
* 18/03/2018
  - Deprecate `g:neoterm_tnew_mod` and `g:neoterm_position` in favor of
    `g:neoterm_default_mod`, which will be used for every new neoterm window.
  - Add the feature of the _last active_ neoterm. When sending a command or
    navigating among neoterms the last one will be marked as the last active and
    it'll be used by default in the next commands.
