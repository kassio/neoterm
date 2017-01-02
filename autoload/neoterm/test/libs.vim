function! neoterm#test#libs#add(lib)
  if has('nvim')
    if index(g:neoterm_test_libs, a:lib) == -1
      call add(g:neoterm_test_libs, a:lib)
    end
  end
endfunction

function! neoterm#test#libs#current(lib)
  let b:neoterm_test_lib = a:lib
endfunction

function! neoterm#test#libs#autocomplete(arg_lead, cmd_line, cursor_pos)
  return filter(g:neoterm_test_libs, 'v:val =~? "'. a:arg_lead. '"')
endfunction
