function! neoterm#test#libs#add(lib)
  if index(g:neoterm_test_libs, a:lib) != 0
    let b:neoterm_test_lib = a:lib
    let g:neoterm_test_lib = a:lib
    call add(g:neoterm_test_libs, a:lib)
  end
endfunction

function! neoterm#test#libs#autocomplete(arg_lead, cmd_line, cursor_pos)
  return filter(g:neoterm_test_libs, 'v:val =~? "'. a:arg_lead. '"')
endfunction
