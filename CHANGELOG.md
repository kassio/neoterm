### 08/04/2020

  - Add option `g:neoterm_repl_r` to set the REPL for the R files.

### 04/04/2020
  - Improve the documentation.
  - Change default behavior to not delete the current buffer, instead creates a
    new buffer for the neoterm. By default, it'll still use the current window,
    but no the current buffer.
  - Add `g:neoterm_clear_cmd` to configure how to clear the terminal.
### 16/03/2020
  - Extract changelog to [CHANGELOG.md](CHANGELOG.md).
  - Revamp README and documentation.

### 14/03/2020
  - Add support for [`jshell`](https://github.com/christo-auer/neoterm.git)(Java REPL).

### 14/02/2020
  - Add support for [`evcxr`](https://github.com/google/evcxr)(Rust REPL).

### 11/11/2019
  - Fix bug with `g:neoterm_fixedsize`. ([\#255](https://github.com/kassio/neoterm/issues/255))

### 07/11/2019
  - Remove `TermClose` neoterm destroy action. This is already called via
      `on_exit` callback. ([\#252](https://github.com/kassio/neoterm/issues/252))
  - Fix neoterm on vim. Vim doesn't accept marked shell.
      ([\#251](https://github.com/kassio/neoterm/issues/251))
  - Fix exception when trying to send a command to an inexistent neoterm buffer.
      ([\#254](https://github.com/kassio/neoterm/issues/254))

### 01/09/2019
  - Use a proper terminal marker for each OS. Unix-like uses `;#neoterm` and
    windows uses `&::neoterm`. (Same strategy used on
    [FZF](https://github.com/junegunn/fzf/commit/5097e563df9c066e307b7923283cf1609ede693e)) ([#246](https://github.com/kassio/neoterm/issues/246))

### 20/08/2019
  - Destroy managed neoterm buffer loaded from session
  - Refactor the neoterm target function, the function the retrieves the desired
    neoterm to act on, to its own autoload function set (neoterm#target#).
  - Only manage neoterm terminals with `TermOpen`. ([#243](https://github.com/kassio/neoterm/issues/243))

### 19/08/2019
  - Only use `TermOpen` when it' available. ([#243](https://github.com/kassio/neoterm/issues/243))

### 18/08/2019
  - Enable neoterm to manage any terminal buffer. The TermOpen event is being
    used to associate neovim terminal with neoterm.
  - Remove deprecated `g:neoterm_open_in_all_tabs` and fix
    `g:neoterm_term_per_tab` ([#237](https://github.com/kassio/neoterm/issues/237)).
  - Better message when trying to execute a command on an already closed
    neoterm. Instead of show the error stacktrace just shows the message:
    "neoterm-X not found (probably already closed)" ([#242](https://github.com/kassio/neoterm/issues/242))

### 21/06/2019
  - Fix bug with window resizing for non-default mods ([#239](https://github.com/kassio/neoterm/issues/239)).

### 07/06/2019
  - `g:neoterm_keep_term_open` keeps hidden terminals open even if they are
    closed without using `:Tclose`

### 11/03/2019
  - Make the `signcolumn=auto` in neoterm buffer.

### 29/01/2019
  - Improve `g:neoterm_open_in_all_tabs` documentation.

### 21/12/2018
  - Add `g:neoterm_term_per_tab`, a way to send the commands to the term
    associated to the vim tab.
  - fix `:Topen` without `g:neoterm_default_mod` wasn't re-opening neoterm
    buffer.

### 17/11/2018
  - add `:Tclear!`, this will clear the neoterm buffer scrollback (history)

### 12/11/2018
  - Use `chansend` instead of `jobsend`, which was deprecated.

### 12/11/2018
  - Fix `E119: Not enough arguments for function: <SNR>112_repl_result_handler`

### 09/11/2018
  - Yet another work with '%' expandability.
    - '%' will be expanded to the current file path, respect g:neoterm_use_relative_path;
    - '\%' will be expanded to '%', not the current file path, useful in Windows.

### 20/07/2018
  - `\%` Will not expand the `%`. (Escaping the `%`)

### 03/03/2018
  - **DEPRECATE g:neoterm_split_on_tnew** - `:Tnew` now accepts vim mods (`:help mods`).
  - Introduce `g:neoterm_tnew_mod` to set a default `:Tnew` mod (`:help mods`).
  - Revamp `:Topen`. Now `:[mods][N]Topen` accepts vim mods (`:h mods`) and a
    target, so if one wants to open the neoterm with id 2 in vertical, one can
    do `:vert 2Topen`.
  - Revamp `:Tclose`. Now `:[N]Tclose[!]` accepts a target, so one can close any
    neoterm by its id.
  - Fix a bug with `:[N]Ttoggle` and also make it accepts the neoterm id.

### 04/03/2018
  - Revamp `:[N]Ttoggle`, now it accepts vim mods (`:help mods`) when the toggle
    is opening the neoterm.
  - Revamp `:[N]T`, now it accepts the target, so one can send the command for
    any neoterm by id, like, to send commands to the neoterm 3, one can do
     `:3T ls`.
  - **DEPRECATE T[N], Topen[N], Tclose[N], Tclear[N], Tkill[N]** - The neoterm
    id was moved to the beginning of the command, so instead of `:T2`, for
    example, one must use `:2T`.

### 07/03/2018
  - Do not call `:bdelete!` if buffer does not exist `term#destroy` was calling
    `neoterm#close` which was causing a cyclic call to `:bdelete!
    <neoterm.buffer_id>`.

### 08/03/2018
  - Add vim's terminal support! 🎉🎉🎉

### 15/03/2018
  - Fix bug where `:[N]T` wasn't accepting quoted arguments, like:
    `:T echo "ls"`.
  - Make handlers/callbacks work in vim. Destroy instance when destroying a
    terminal.

### 18/03/2018
  - Deprecate `g:neoterm_tnew_mod` and `g:neoterm_position` in favor of
    `g:neoterm_default_mod`, which will be used for every new neoterm window.
  - Add the feature of the _last active_ neoterm. When sending a command or
    navigating among neoterms the last one will be marked as the last active and
    it'll be used by default in the next commands.
