" Internal: Creates a new neoterm buffer.
function! neoterm#new(...)
  let handlers = len(a:000) ? a:1 : {}
  call neoterm#window#create(handlers, "")
endfunction

function! neoterm#tnew()
  call neoterm#window#create({}, "tnew")
endfunction

function! neoterm#toggle()
  if g:neoterm.has_any()
    let instance = g:neoterm.last()
    let instance.origin = exists('*win_getid') ? win_getid() : 0

    if neoterm#tab_has_neoterm()
      call instance.close()
    else
      call instance.open()
    end
  else
    call neoterm#new()
  end
endfunction

" Internal: Creates a new neoterm buffer, or opens if it already exists.
function! neoterm#open()
  if !neoterm#tab_has_neoterm()
    if !g:neoterm.has_any()
      call neoterm#new()
    else
      call g:neoterm.last().open()
    end
  end
endfunction

function! neoterm#close(...)
  let instance = g:neoterm.last()
  let instance.origin = exists('*win_getid') ? win_getid() : 0

  let force = get(a:, "1", 0)
  if g:neoterm.has_any()
    call instance.close(force)
  end
endfunction

function! neoterm#closeAll(...)
  let origin = exists('*win_getid') ? win_getid() : 0

  let force = get(a:, "1", 0)
  for instance in values(g:neoterm.instances)
    let instance.origin = origin
    call instance.close(force)
  endfor
endfunction

" Public: Executes a command on terminal.
" Evaluates any "%" inside the command to the full path of the current file.
function! neoterm#do(command)
  let command = neoterm#expand_cmd(a:command)
  call neoterm#exec([command, g:neoterm_eof])
endfunction

" Internal: Loads a terminal, if it is not loaded, and execute a list of
" commands.
function! neoterm#exec(command)
  if !g:neoterm.has_any() || g:neoterm_open_in_all_tabs
    call neoterm#open()
  end

  call g:neoterm.last().exec(a:command)
endfunction

function! neoterm#map_for(command)
  exec "nnoremap <silent> "
        \ . g:neoterm_automap_keys .
        \ " :T " . neoterm#expand_cmd(a:command) . "<cr>"
endfunction

" Internal: Expands "%" in commands to current file full path.
function! neoterm#expand_cmd(command)
  let command = substitute(a:command, '%\(:[phtre]\)\+', '\=expand(submatch(0))', "g")

  if g:neoterm_use_relative_path
    let path = expand('%')
  else
    let path = expand('%:p')
  end

  return substitute(command, '%', path, "g")
endfunction

" Internal: Open a new split with the current neoterm buffer if there is one.
"
" Returns: 1 if a neoterm split is opened, 0 otherwise.
function! neoterm#tab_has_neoterm()
  if g:neoterm.has_any()
    let buffer_id = g:neoterm.last().buffer_id
    return bufexists(buffer_id) > 0 && bufwinnr(buffer_id) != -1
  end
endfunction

" Internal: Clear the current neoterm buffer. (Send a <C-l>)
function! neoterm#clear()
  silent call g:neoterm.last().clear()
endfunction

function! neoterm#normal(cmd)
  silent call g:neoterm.last().normal(a:cmd)
endfunction

function! neoterm#vim_exec(cmd)
  silent call g:neoterm.last().vim_exec(a:cmd)
endfunction

" Internal: Kill current process on neoterm. (Send a <C-c>)
function! neoterm#kill()
  silent call g:neoterm.last().kill()
endfunction

function! neoterm#list(arg_lead, cmd_line, cursor_pos)
  return filter(keys(g:neoterm.instances), 'v:val =~? "'. a:arg_lead. '"')
endfunction
