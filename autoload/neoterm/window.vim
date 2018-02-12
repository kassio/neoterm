function! neoterm#window#create(handlers, source)
  let l:origin = exists('*win_getid') ? win_getid() : 0

  if !has_key(g:neoterm, 'term')
    exec 'source ' . globpath(&runtimepath, 'autoload/neoterm.term.vim')
  end

  if g:neoterm_split_on_tnew || a:source !=# 'tnew'
    call s:new_split()
  end

  call s:term_creator(a:handlers, l:origin)
  call s:after_open(l:origin)
endfunction

function! s:new_split(...)
  let l:hidden=&hidden
  let &hidden=0
  let l:cmd = printf('botright%s ', g:neoterm_size)
  let l:cmd .= g:neoterm_position ==# 'horizontal' ? 'new' : 'vnew'

  exec a:0 ? printf('%s +buffer%s', l:cmd, a:1) : l:cmd
  let &hidden=l:hidden
endfunction

function! s:term_creator(handlers, origin)
  let b:neoterm_id = g:neoterm.term.new(a:origin, a:handlers).id
endfunction

function! neoterm#window#reopen(instance)
  call s:new_split(a:instance.buffer_id)
  call s:after_open(a:instance.origin)
endfunction

function! s:after_open(origin)
  setf neoterm
  setlocal nonumber norelativenumber scrolloff=0 

  if g:neoterm_fixedsize
    setlocal winfixheight winfixwidth
  end

  if g:neoterm_autoinsert
    startinsert
  elseif !g:neoterm_autojump
    if a:origin
      call win_gotoid(a:origin)
    else
      wincmd p
    end
  end
endfunction
