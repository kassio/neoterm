" Executes a command on terminal.
" Evaluates any "%" inside the command to the full path of the current file.
function! neoterm#do(command)
  let command = substitute(a:command, '%', expand('%:p'), 'g')

  call neoterm#exec([command, ''])
endfunction

" Loads a terminal, if it is not loaded, and execute a list of commands.
function! neoterm#exec(list)
  call <sid>open_terminal_cmd()

  call jobsend(g:neoterm_terminal_jid, a:list)
endfunction

function! neoterm#close_all()
  let all_buffers = range(1, bufnr('$'))
  let term_buffers = filter(all_buffers, 'bufname(v:val) =~ "term:\/\/.*"')

  exec 'bw! ' . join(term_buffers, ' ')
endfunction

function! neoterm#clear()
  call neoterm#do(g:neoterm_clear_cmd)
endfunction

function! s:open_terminal_cmd()
  let current_window = winnr()

  if !exists('g:neoterm_terminal_jid')
    let open_cmd = <sid>split_cmd()." ".g:neoterm_size." new | term $SHELL"
  elseif bufwinnr(g:neoterm_buffer_id) == -1
    let open_cmd = <sid>split_cmd()." ".g:neoterm_size." sbuffer ".g:neoterm_buffer_id
  end

  exec open_cmd | exec current_window . "wincmd w | set noim"
endfunction

function! s:split_cmd()
  if g:neoterm_position == "horizontal"
    return "botright"
  else
    return "botright vert"
  end
endfunction
