function! neoterm#window#create(handlers, source)
  let origin = exists('*win_getid') ? win_getid() : 0

  if !has_key(g:neoterm, "term")
    exec "source " . globpath(&rtp, "autoload/neoterm.term.vim")
  end

  if g:neoterm_split_on_tnew || a:source != 'tnew'
    call s:new_split()
  end

  call s:term_creator(a:handlers, origin)
  call s:after_open(origin)
endfunction

function! s:new_split(...)
  if g:neoterm_position == "horizontal"
    let cmd = "botright".g:neoterm_size." new "
  else
    let cmd = "botright".g:neoterm_size." vnew "
  end

  exec a:0 ? cmd." +buffer".a:1 : cmd
endfunction

function! s:term_creator(handlers, origin)
  let instance = g:neoterm.term.new(a:origin, a:handlers)
  let b:neoterm_id = instance.id
endfunction

function! neoterm#window#reopen(instance)
  let origin = exists('*win_getid') ? win_getid() : 0

  call s:new_split(a:instance.buffer_id)

  call s:after_open(a:instance.origin)
endfunction

function! s:after_open(origin)
  setlocal nonumber norelativenumber

  if g:neoterm_fixedsize
    setlocal winfixheight winfixwidth
  end

  if g:neoterm_autoinsert
    startinsert
  else
    if a:origin
      call win_gotoid(a:origin)
    else
      wincmd p
    end
  end
endfunction
