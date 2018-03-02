function! neoterm#new(...)
  let l:opts = extend(get(a:, 1, {}), {
        \ 'source': '',
        \ 'handlers': {},
        \ 'mod': '',
        \ 'origin': exists('*win_getid') ? win_getid() : 0
        \ }, 'keep')

  call neoterm#term#load()
  call s:create_window(l:opts)
  call g:neoterm.term.new(l:opts)
  call s:after_open(l:opts.origin)
endfunction

function! s:create_window(...)
  let l:opts = extend(get(a:, 1, {}), {
        \ 'buffer_id': 0,
        \ 'source': '',
        \ 'mod': ''
        \ }, 'keep')

  if l:opts.source ==# 'tnew'
    if l:opts.mod !=# ''
      exec printf('%s %snew', l:opts.mod, g:neoterm_size)
    end
  else
    let l:hidden=&hidden
    let &hidden=0

    let l:cmd = printf('botright%s ', g:neoterm_size)
    let l:cmd .= g:neoterm_position ==# 'horizontal' ? 'new' : 'vnew'
    if l:opts.buffer_id > 0
      let l:cmd .= printf(' +buffer%s', l:opts.buffer_id)
    end

    exec l:cmd

    let &hidden=l:hidden
  end
endfunction

function! neoterm#reopen(instance)
  call s:create_window({ 'buffer_id': a:instance.buffer_id })
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

function! neoterm#toggle()
  call s:toggle(g:neoterm.last())
endfunction

function! neoterm#toggleAll()
  for l:instance in values(g:neoterm.instances)
    call s:toggle(l:instance)
  endfor
endfunction

function! s:toggle(instance)
  if g:neoterm.has_any()
    let a:instance.origin = exists('*win_getid') ? win_getid() : 0

    if neoterm#tab_has_neoterm()
      call a:instance.close()
    else
      call a:instance.open()
    end
  else
    call neoterm#new()
  end
endfunction

function! neoterm#open()
  if !neoterm#tab_has_neoterm()
    if !g:neoterm.has_any()
      call neoterm#new()
    else
      call g:neoterm.last().open()
    end
  end
endfunction

function! neoterm#close(...)
  let l:instance = g:neoterm.last()
  let l:instance.origin = exists('*win_getid') ? win_getid() : 0

  let l:force = get(a:, '1', 0)
  if g:neoterm.has_any()
    call l:instance.close(l:force)
  end
endfunction

function! neoterm#closeAll(...)
  let l:origin = exists('*win_getid') ? win_getid() : 0

  let l:force = get(a:, '1', 0)
  for l:instance in values(g:neoterm.instances)
    let l:instance.origin = l:origin
    call l:instance.close(l:force)
  endfor
endfunction

function! neoterm#do(command)
  let l:command = neoterm#expand_cmd(a:command)
  call neoterm#exec([l:command, g:neoterm_eof])
endfunction

function! neoterm#exec(command)
  if !g:neoterm.has_any() || g:neoterm_open_in_all_tabs
    call neoterm#open()
  end

  call g:neoterm.last().exec(a:command)
endfunction

function! neoterm#map_for(command)
  exec 'nnoremap <silent> '
        \ . g:neoterm_automap_keys .
        \ ' :T ' . neoterm#expand_cmd(a:command) . '<cr>'
endfunction

function! neoterm#expand_cmd(command)
  let l:command = substitute(a:command, '%\(:[phtre]\)\+', '\=expand(submatch(0))', 'g')

  if g:neoterm_use_relative_path
    let l:path = expand('%')
  else
    let l:path = expand('%:p')
  end

  return substitute(l:command, '%', l:path, 'g')
endfunction

function! neoterm#tab_has_neoterm()
  if g:neoterm.has_any()
    let l:buffer_id = g:neoterm.last().buffer_id
    return bufexists(l:buffer_id) > 0 && bufwinnr(l:buffer_id) != -1
  end
endfunction

function! neoterm#clear()
  silent call g:neoterm.last().clear()
endfunction

function! neoterm#normal(cmd)
  silent call g:neoterm.last().normal(a:cmd)
endfunction

function! neoterm#vim_exec(cmd)
  silent call g:neoterm.last().vim_exec(a:cmd)
endfunction

function! neoterm#kill()
  silent call g:neoterm.last().kill()
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
