if !exists('g:neoterm_repl_enable_ipython_paste_magic')
  let g:neoterm_repl_enable_ipython_paste_magic = 0
end

function! neoterm#repl#python#is_valid(value) abort
  let l:cmd =  type(a:value) == v:t_list ? join(a:value) : a:value

  if l:cmd =~# '\<ipython\>'
    return executable('ipython')
  elseif l:cmd =~# '\<jupyter\>'
    return executable('jupyter')
  elseif l:cmd =~# '\<python\>'
    return executable('python')
  else
    return v:false
  end
endfunction

function! neoterm#repl#python#exec(command) abort
  if  join(g:neoterm_repl_command) =~# 'ipython'
    if g:neoterm_repl_enable_ipython_paste_magic  == 1
      let l:cmd = s:ipython_magic_command_for(a:command)
    else
      let l:cmd = s:ipython_command_for(a:command)
    endif
  else
    let l:cmd = s:python_command_for(a:command)
  end

  call g:neoterm.repl.instance().exec(add(l:cmd, g:neoterm_eof))
endfunction

function! s:ipython_magic_command_for(command) abort
  call setreg('+', a:command, 'l')
  return ['%paste']
endfunction

function! s:ipython_command_for(command) abort
  let pycommand = filter(a:command, { _idx, val -> val !~# "^\\s*$" })

  return get(l:, 'ipycommand', pycommand)
endfunction

function! s:python_command_for(command) abort
  let pycommand = filter(a:command, { _idx, val -> val !~ "^\\s*$" })
  let index = 0
  let ipycommand = []
  let prev_line = ''

  while index < (len(pycommand))
    let prev_indent = len(matchstr(prev_line, '^\s*'))
    let curr_line = pycommand[index]
    let curr_indent = len(matchstr(curr_line, '^\s*'))

    if ((prev_indent > curr_indent) && curr_indent == 0)
      call add(ipycommand, '')
    endif
    call add(ipycommand, curr_line)

    let prev_line = curr_line
    let l:index += 1
  endwhile

  return get(l:, 'ipycommand', pycommand)
endfunction
