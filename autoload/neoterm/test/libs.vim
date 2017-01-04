function! neoterm#test#libs#add(lib)
  if has('nvim')
    if index(g:neoterm_test_libs, a:lib) == -1
      let g:neoterm_test_lib = a:lib
      call add(g:neoterm_test_libs, a:lib)
    end

    let b:neoterm_test_lib = a:lib
  end
endfunction

function! neoterm#test#libs#autocomplete(arg_lead, cmd_line, cursor_pos)
  return filter(g:neoterm_test_libs, 'v:val =~? "'. a:arg_lead. '"')
endfunction
