" Loads a terminal, if it is not loaded, and execute a list of commands.
function! neoterm#exec(list)
  if g:neoterm_keep_term_open
    call neoterm#open()
    call jobsend(g:neoterm_terminal_jid, a:list)
  else
    exec <sid>split_cmd()
    call termopen(extend([&sh, &shcf], a:list), { 'name': 'NEOTERM' })
    startinsert
  end
endfunction

" Executes a command on terminal.
" Evaluates any "%" inside the command to the full path of the current file.
function! neoterm#do(command)
  let command = neoterm#expand_cmd(a:command)

  silent call neoterm#exec([command, ''])
endfunction

function! neoterm#expand_cmd(command)
  return substitute(a:command, '%', expand('%:p'), 'g')
endfunction

function! neoterm#open()
  if !exists('g:neoterm_terminal_jid') " there is no neoterm running
    let open_cmd = <sid>split_cmd()." +call\\ termopen(&sh,\\{'name':'NEOTERM'})"
  elseif !<sid>tab_has_neoterm() " there is no neoterm on current tab
    let open_cmd = <sid>split_cmd()." +b".g:neoterm_buffer_id
  else " neoterm is already running on current tab
    return
  end

  let current_window = winnr()
  exec open_cmd
  exec current_window . "wincmd w | set noim"
endfunction

function! s:split_cmd()
  if g:neoterm_position == "horizontal"
    return "botright ".g:neoterm_size." new"
  else
    return "botright vert".g:neoterm_size." new"
  end
endfunction

function! s:tab_has_neoterm()
  return exists('g:neoterm_buffer_id') &&
        \ bufexists(g:neoterm_buffer_id) > 0 &&
        \ bufwinnr(g:neoterm_buffer_id) != -1
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
      exec bufwinnr(a:buffer) . "hide"
    end
  else
    exec bufwinnr(a:buffer) . "close"
  end
endfunction

function! neoterm#clear()
  silent call neoterm#exec(["\<c-l>"])
endfunction

function! neoterm#kill()
  silent call neoterm#exec(["\<c-c>"])
endfunction
