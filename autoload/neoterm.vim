function! neoterm#new(...)
  if has('nvim')
    call neoterm#neovim#load()
  end

  let l:opts = extend(get(a:, 1, {}), {
        \ 'source': '',
        \ 'handlers': {},
        \ 'mod': '',
        \ 'buffer_id': 0,
        \ 'origin': s:winid()
        \ }, 'keep')

  let l:instance = extend(copy(g:neoterm.prototype), l:opts)
  call s:create_window(l:instance)

  let l:instance.id = g:neoterm.next_id()
  let l:instance.name = printf('neoterm-%s', l:instance.id)
  let l:instance.source = ''
  let l:instance.termid = g:neoterm.new(l:instance)
  let l:instance.buffer_id = bufnr('')

  call s:after_open(l:instance)

  let g:neoterm.instances[l:instance.id] = l:instance
endfunction

function! neoterm#open(opts)
  let l:opts = extend(a:opts, { 'mod': '', 'target': 0 }, 'keep')
  let l:instance = s:target(l:opts)

  if empty(l:instance)
    call neoterm#new({ 'mod': l:opts.mod, 'source': 'open' })
    return
  end

  if l:opts.mod !=# ''
    let l:instance.mod = l:opts.mod
  end

  let l:instance.origin = s:winid()
  call s:create_window(l:instance)
  call s:after_open(l:instance)

  if g:neoterm_autoscroll
    call l:instance.normal('G')
  end
endfunction

function! neoterm#close(opts)
  let l:opts = extend(a:opts, { 'target': 0, 'force': 0 }, 'keep')
  let l:instance = s:target(l:opts)

  if !empty(l:instance)
    let l:instance.origin = s:winid()

    try
      if l:opts.force || !g:neoterm_keep_term_open
        exec printf('%sbdelete!', l:instance.buffer_id)
      else
        exec printf('%shide', bufwinnr(l:instance.buffer_id))
      end

      if l:instance.origin
        call win_gotoid(l:instance.origin)
      end
    catch /^Vim\%((\a\+)\)\=:E444/
      " noop
      " Avoid messages when the terminal is the last window
    endtry
  end
endfunction

function! neoterm#closeAll(opts)
  for l:instance in values(g:neoterm.instances)
    call neoterm#close(extend(a:opts, { 'target': l:instance.id }))
  endfor
endfunction

function! s:after_open(instance)
  let b:neoterm_id = a:instance.id
  let b:term_title = a:instance.name
  setf neoterm
  setlocal nonumber norelativenumber

  if g:neoterm_fixedsize
    setlocal winfixheight winfixwidth
  end

  if g:neoterm_autoinsert
    startinsert
  elseif !g:neoterm_autojump
    if a:instance.origin
      call win_gotoid(a:instance.origin)
    else
      wincmd p
    end
  end
endfunction

function! neoterm#toggle(opts)
  let l:opts = extend(a:opts, { 'mod': '', 'target': 0 }, 'keep')
  let l:instance = s:target(l:opts)

  if g:neoterm.has_any()
    if bufwinnr(l:instance.buffer_id) > -1
      call neoterm#close(l:opts)
    else
      call neoterm#open(l:opts)
    end
  else
    call neoterm#new()
  end
endfunction

function! neoterm#toggleAll()
  for l:id in keys(g:neoterm.instances)
    call neoterm#toggle({ 'target': l:id })
  endfor
endfunction

function! neoterm#do(opts)
  let l:instance = s:target({ 'target': get(a:opts, 'target', 0) })
  let l:command = s:expand(a:opts.cmd)

  if empty(l:instance)
    if !g:neoterm.has_any()
      call neoterm#new({})
    end
    let l:instance = g:neoterm.last()
  end

  call l:instance.do(l:command)
endfunction

function! neoterm#exec(opts)
  let l:instance = s:target({ 'target': get(a:opts, 'target', 0) })
  let l:command = s:expand(a:opts.cmd)

  if empty(l:instance) && g:neoterm.has_any()
    let l:instance = g:neoterm.last()
  end

  call l:instance.exec(a:opts.cmd)
endfunction

function! neoterm#map_for(command)
  exec 'nnoremap <silent> '
        \ . g:neoterm_automap_keys .
        \ ' :T ' . s:expand(a:command) . '<cr>'
endfunction

function! neoterm#clear(opts)
  call neoterm#exec(extend(a:opts, { 'cmd': "\<c-l>" }))
endfunction

function! neoterm#kill(opts)
  call neoterm#exec(extend(a:opts, { 'cmd': "\<c-c>" }))
endfunction

function! neoterm#normal(cmd)
  silent call g:neoterm.last().normal(a:cmd)
endfunction

function! neoterm#vim_exec(cmd)
  silent call g:neoterm.last().vim_exec(a:cmd)
endfunction

function! neoterm#list(arg_lead, cmd_line, cursor_pos)
  return filter(keys(g:neoterm.instances), 'v:val =~? "'. a:arg_lead. '"')
endfunction

function! neoterm#next()
  function! s:next(buffers, index)
    let l:next_index = a:index + 1
    let l:next_index = l:next_index > (len(a:buffers) - 1) ? 0 : l:next_index
    exec printf('%sbuffer', a:buffers[l:next_index])
  endfunction

  call s:can_navigate(function('s:next'))
endfunction

function! neoterm#previous()
  function! s:previous(buffers, index)
    let l:previous_index = a:index - 1
    let l:previous_index = l:previous_index < 0 ? (len(a:buffers) - 1) : l:previous_index
    exec printf('%sbuffer', a:buffers[l:previous_index])
  endfunction

  call s:can_navigate(function('s:previous'))
endfunction

function! s:create_window(instance)
  if a:instance.source ==# 'tnew'
    let l:mod = a:instance.mod !=# '' ? a:instance.mod : g:neoterm_tnew_mod
    if l:mod !=# ''
      exec printf('%s %snew', l:mod, g:neoterm_size)
    end
  else
    let l:hidden=&hidden
    let &hidden=0

    if a:instance.mod ==# ''
      let a:instance.mod = g:neoterm_position ==# 'horizontal' ? 'botright' : 'vertical'
    end

    let l:cmd = printf('%s %snew', a:instance.mod, g:neoterm_size)
    if a:instance.buffer_id > 0
      let l:cmd .= printf(' +buffer%s', a:instance.buffer_id)
    end

    exec l:cmd

    let &hidden=l:hidden
  end
endfunction

function! s:target(opts)
  if a:opts.target > 0
    if has_key(g:neoterm.instances, a:opts.target)
      return g:neoterm.instances[a:opts.target]
    else
      echoe printf("neoterm with id %s not found", a:opts.target)
      return {}
    end
  elseif g:neoterm.has_any()
    return g:neoterm.last()
  end
endfunction

function! s:can_navigate(navigate)
  if &buftype ==? 'terminal'
    if len(g:neoterm.instances) > 1
      let l:buffers = map(copy(g:neoterm.instances), { _, instance -> instance.buffer_id })
      let l:buffers_ids = values(l:buffers)
      let l:current_buffer = l:buffers[b:neoterm_id]
      let l:current_index = index(l:buffers_ids, l:current_buffer)
      let l:hidden = &hidden

      set hidden
      call a:navigate(l:buffers_ids, l:current_index)
      let &hidden = l:hidden
    else
      echo 'You do not have other terminals'
    end
  else
    echo 'You must be in a terminal to use this command'
  end
endfunction

function! s:winid()
  return exists('*win_getid') ? win_getid() : 0
endfunction

function! s:expand(command)
  let l:command = substitute(a:command, '%\(:[phtre]\)\+', '\=expand(submatch(0))', 'g')
  let l:path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')

  return substitute(l:command, '%', l:path, 'g')
endfunction
