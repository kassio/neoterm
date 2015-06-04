" Executes a command on terminal.
" Evaluates any "%" inside the command to the full path of the current file.
function! neoterm#do(command)
  let command = neoterm#expand_cmd(a:command)

  call neoterm#exec([command, ''])
endfunction

function! neoterm#expand_cmd(command)
  return substitute(a:command, '%', expand('%:p'), 'g')
endfunction

" Loads a terminal, if it is not loaded, and execute a list of commands.
function! neoterm#exec(list)
  if g:neoterm_keep_term_open
    call <sid>open_terminal_cmd()
    call jobsend(g:neoterm_terminal_jid, a:list)
  else
    let cmd = join(a:list, "\n")
    exec <sid>split_cmd() | call termopen(cmd) | startinsert
  end
endfunction

function! s:open_terminal_cmd()
  if exists('g:neoterm_buffer_id') &&
        \ bufwinnr(g:neoterm_buffer_id) == -1 &&
        \ bufexists(g:neoterm_buffer_id) > 0
    let open_cmd = <sid>split_cmd()." +b".g:neoterm_buffer_id
  elseif !exists('g:neoterm_terminal_jid')
    let open_cmd = <sid>split_cmd()." +term\ $SHELL"
  else
    return
  end

  let current_window = winnr()
  exec open_cmd | exec current_window . "wincmd w | set noim"
endfunction

function! s:split_cmd()
  if g:neoterm_position == "horizontal"
    return "botright ".g:neoterm_size." new"
  else
    return "botright vert".g:neoterm_size." new"
  end
endfunction

function! neoterm#close_all()
  let all_buffers = range(1, bufnr('$'))

  for b in all_buffers
    if bufname(b) =~ "term:\/\/.*"
      call <sid>close_term_buffer(b)
    end
  endfor
endfunction

function! s:close_term_buffer(buffer)
  if g:neoterm_keep_term_open
    if bufwinnr(a:buffer) > 0 " check if the buffer is visible
      exec bufwinnr(a:buffer) . " hide"
    end
  else
    exec 'bd! ' . a:buffer
  end
endfunction

function! neoterm#clear()
  call neoterm#do(g:neoterm_clear_cmd)
endfunction
