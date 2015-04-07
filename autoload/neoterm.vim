" Executes a command on terminal.
" Evaluates any "%" inside the command to the full path of the current file.
function! neoterm#do(command)
  let command = substitute(a:command, '%', expand('%:p'), 'g')

  call neoterm#exec([command, ''])
endfunction

" Loads a terminal, if it is not loaded, and execute a list of commands.
function! neoterm#exec(list)
  if !exists('g:neoterm_current_id')
    let current_window = winnr()
    if g:neoterm_position == 'horizontal'
      let split_cmd = "botright new | term"
    else
      let split_cmd = "botright vert new | term"
    end

    exec split_cmd | exec current_window . "wincmd w | set noim"
  end

  call jobsend(g:neoterm_current_id, a:list)
endfunction

function! neoterm#close_all()
  let all_buffers = range(0, bufnr('$'))
  let term_buffers = filter(all_buffers, 'bufname(v:val) =~ "term:\/\/.*"')

  exec 'bw! ' . join(term_buffers, ' ')
endfunction

function! neoterm#clear()
  call neoterm#do(g:neoterm_clear_cmd)
endfunction
