"init python specific settings
if !exists('g:neoterm_repl_ipy_magic')
  let g:neoterm_repl_ipy_magic = 0
end

if !exists('g:neoterm_ipy_cellmark')
  let g:neoterm_repl_ipy_cellmark = "# %%"
end

function! neoterm#repl#python#cell()
    let l:lnum1 = search(g:neoterm_repl_ipy_cellmark, 'Wb') + 1
    let l:lnum2 = search(g:neoterm_repl_ipy_cellmark, 'W') - 1
    if l:lnum2 == -1
      let l:lnum2 = line('$')
    endif
    let l:lines = getline(l:lnum1, l:lnum2)
    call g:neoterm.repl.exec(l:lines)
endfunction

function! neoterm#repl#python#run()
  if join(g:neoterm_repl_command) =~ "ipython"
    let l:cmd = ["%run " . expand('%')]
  else
    let l:cmd = ['exec(open("' . expand('%') . '").read())']
  endif
  call g:neoterm.repl.instance().exec(add(l:cmd, g:neoterm_eof))
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
