function! neoterm#window#create(handlers, source)
  let win_id = exists('*win_getid') ? win_getid() : 0

  if !has_key(g:neoterm, "term")
    exec "source " . globpath(&rtp, "autoload/neoterm.term.vim")
  end

  if a:source == 'tnew' && !g:neoterm_split_on_tnew
    call s:term_creator(a:handlers)
  else
    call s:new_split()
    call s:term_creator(a:handlers)
  end

  if a:source == 'test' && g:neoterm_run_tests_bg
    hide
  elseif g:neoterm_autoinsert
    startinsert
  elseif g:neoterm_keep_term_open
    if win_id
      call win_gotoid(win_id)
    else
      wincmd p
    end
  else
    startinsert
  end
endfunction

function! s:new_split()
  let current_window = winnr()

  if g:neoterm_position == "horizontal"
    exec "botright".g:neoterm_size." new "
  else
    exec "botright vert".g:neoterm_size." new "
  end

  return current_window
endfunction

function! s:term_creator(handlers)
  let instance = g:neoterm.term.new(a:handlers)
  call instance.mappings()
  let b:neoterm_id = instance.id
endfunction

function! neoterm#window#reopen(buffer_id)
  let win_id = exists('*win_getid') ? win_getid() : 0

  if g:neoterm_position == "horizontal"
    exec "botright ".g:neoterm_size."split +buffer".a:buffer_id
  else
    exec "botright ".g:neoterm_size."vsplit +buffer".a:buffer_id
  end

  if win_id
    call win_gotoid(win_id)
  else
    wincmd p
  end
endfunction
