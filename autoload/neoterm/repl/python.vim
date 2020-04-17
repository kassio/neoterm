"init python specific settings
if !exists('g:neoterm_repl_ipy_magic')
  let g:neoterm_repl_ipy_magic = 0
end

function! neoterm#repl#python#is_valid(value)
  let l:pyCmd = 0
  let l:invalid = 0
  if type(a:value) == v:t_list
    for i in range(len(a:value))
      if a:value[i] =~ 'python'
        let l:pyCmd = 1
        if a:value[i] == 'ipython'
          let g:neoterm_repl_python[i] = 'ipython --no-autoindent'
        endif
      endif
      if executable(split(a:value[i])[0]) == 0
        let l:invalid = 1
      endif
    endfor
  else
    if a:value =~ 'python'
      let l:pyCmd = 1
      if a:value == 'ipython'
       let g:neoterm_repl_python = 'ipython --no-autoindent'
    endif
    endif
    if executable(split(a:value)[0]) == 0
      let l:invalid = 1
    endif
  endif
  if l:pyCmd == 1 && l:invalid == 0
      return 1
  else
      return 0
  endif
endfunction

function! neoterm#repl#python#exec(command)
  if g:neoterm_repl_ipy_magic == 1 && join(g:neoterm_repl_command) =~ "ipython"
    call setreg('+', a:command, 'l')
    let l:cmd = ["%paste"]
  else
    let pycommand = filter(a:command, 'v:val !~ "^\\s*$"')
    if join(g:neoterm_repl_command) !~ 'ipython'
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
    endif
    let l:cmd = get(l:, 'ipycommand', pycommand)
  endif
    call g:neoterm.repl.instance().exec(add(l:cmd, g:neoterm_eof))
endfunction
