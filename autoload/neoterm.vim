" Internal: Loads a terminal, if it is not loaded, and execute a list of
" commands.
function! neoterm#exec(list, ...)
  let current_window = winnr()

  call neoterm#open(get(a:, '1', {}))
  call jobsend(g:neoterm_terminal_jid, a:list)

  if g:neoterm_keep_term_open
    silent exec current_window . "wincmd w | set noinsertmode"
  else
    call jobsend(g:neoterm_terminal_jid, ["\<c-d>"])
    startinsert
  end
endfunction

" Internal: Creates a new neoterm buffer, or opens if it already exists.
function! neoterm#open(...)
  let opts = extend({ 'name': 'NEOTERM' }, get(a:, '1', {}))

  if !exists('g:neoterm_terminal_jid') " there is no neoterm running
    exec <sid>split_cmd()
    call termopen([&sh], opts)
  elseif !<sid>tab_has_neoterm() " there is no neoterm on current tab
    exec <sid>split_cmd()
    exec "buffer ".g:neoterm_buffer_id
  end
endfunction

function! s:split_cmd()
  if g:neoterm_position == "horizontal"
    return "botright ".g:neoterm_size." new"
  else
    return "botright vert".g:neoterm_size." new"
  end
endfunction

" Internal: Verifies if neoterm is open for current tab.
function! s:tab_has_neoterm()
  return exists('g:neoterm_buffer_id') &&
        \ bufexists(g:neoterm_buffer_id) > 0 &&
        \ bufwinnr(g:neoterm_buffer_id) != -1
endfunction

" Public: Executes a command on terminal.
" Evaluates any "%" inside the command to the full path of the current file.
function! neoterm#do(command)
  let command = neoterm#expand_cmd(a:command)

  call neoterm#exec([command, ''])
endfunction

" Internal: Expands "%" in commands to current file full path.
function! neoterm#expand_cmd(command)
  return substitute(a:command, '%', expand('%:p'), 'g')
endfunction

" Internal: Closes/Hides all neoterm buffers.
function! neoterm#close_all()
  let all_buffers = range(1, bufnr('$'))

  for b in all_buffers
    if bufname(b) =~ "term:\/\/.*NEOTERM"
      call <sid>close_term_buffer(b)
    end
  endfor
endfunction

" Internal: Closes/Hides a given buffer.
function! s:close_term_buffer(buffer)
  if g:neoterm_keep_term_open
    if bufwinnr(a:buffer) > 0 " check if the buffer is visible
      exec bufwinnr(a:buffer) . "hide"
    end
  else
    exec bufwinnr(a:buffer) . "close"
  end
endfunction

" Internal: Clear the current neoterm buffer. (Send a <C-l>)
function! neoterm#clear()
  silent call neoterm#exec(["\<c-l>"])
endfunction

" Internal: Kill current process on neoterm. (Send a <C-c>)
function! neoterm#kill()
  silent call neoterm#exec(["\<c-c>"])
endfunction
