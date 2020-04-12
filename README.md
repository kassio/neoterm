# neoterm

 ```
 __   _ _______  _____  _______ _______  ______ _______
 | \  | |______ |     |    |    |______ |_____/ |  |  |
 |  \_| |______ |_____|    |    |______ |    \_ |  |  |
```


Forked from:
https://github.com/kassio/neoterm


Branch demo:
![1](https://raw.githubusercontent.com/incoggnito/neoterm/master/assets/sample.gif)


Some new settings:
```vim
let g:neoterm_default_mod = 'vertical'

# use python in a virtual environment
let g:neoterm_repl_python_venv = 'conda activate py3conda'

# set the repl
let g:neoterm_repl_python = 'ipython'

# clear any startup screen like neofetchk
let g:neoterm_clean_startup = 1

# use the paste magic command
let g:neoterm_repl_ipython_magic = 1

# define the cell marker
let g:neoterm_repl_cellmarker = '^# %%'
```
