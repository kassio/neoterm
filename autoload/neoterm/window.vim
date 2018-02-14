function! neoterm#window#create(opts)
  let l:origin = exists('*win_getid') ? win_getid() : 0

  if !has_key(g:neoterm, 'term')
    exec 'source ' . globpath(&runtimepath, 'autoload/neoterm.term.vim')
  end

  if g:neoterm_split_on_tnew || a:opts.source !=# 'tnew'
    call s:new_split({'position': a:opts.position})
  end

  call s:term_creator(a:opts.handlers, l:origin)
  call s:after_open(l:origin)
endfunction

function! s:mods(given)
  if a:given !=# ''
    return a:given
  else
    return g:neoterm_position ==# 'horizontal' ? '' : 'vertical'
  end
endfunction

function! s:new_split(opts)
  let l:hidden=&hidden
  let &hidden=0
  let l:cmd = printf('%s %s new', s:mods(a:opts.position), g:neoterm_size)

  if get(a:opts, 'buffer', 0) > 0
    exec printf('%s +buffer%s', l:cmd, a:opts.buffer)
  else
    exec l:cmd
  end

  let &hidden=l:hidden
endfunction

function! s:term_creator(handlers, origin)
  let b:neoterm_id = g:neoterm.term.new(a:origin, a:handlers).id
endfunction

function! neoterm#window#reopen(instance)
  call s:new_split({'buffer': a:instance.buffer_id})
  call s:after_open(a:instance.origin)
endfunction

function! s:after_open(origin)
  setf neoterm
  setlocal nonumber norelativenumber

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
