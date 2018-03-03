function! neoterm#new(...)
  call s:term_load()

  let l:opts = extend(get(a:, 1, {}), {
        \ 'source': '',
        \ 'handlers': {},
        \ 'mod': '',
        \ 'buffer_id': 0,
        \ 'origin': exists('*win_getid') ? win_getid() : 0
        \ }, 'keep')


  let l:instance = extend(copy(g:neoterm.prototype), l:opts)
  let l:instance.id = g:neoterm.next_id()
  let l:instance.name = printf('neoterm-%s', l:instance.id)

  call s:create_window(l:instance)

  let l:instance.source = ''
  let l:instance.termid = g:neoterm.new(l:instance)
  let l:instance.buffer_id = bufnr('')

  call s:after_open(l:instance)

  let g:neoterm.instances[l:instance.id] = l:instance
endfunction

function! s:term_load()
  if has('nvim')
    call neoterm#neovim#load()
  end
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

function! neoterm#open(opts)
  let l:opts = extend(a:opts, {
        \ 'mod': '',
        \ 'target': 0
        \}, 'keep')

  let l:instance = s:target(l:opts)

  if empty(l:instance)
    call neoterm#new({ 'mod': l:opts.mod, 'source': 'open' })
    return
  end

  if l:opts.mod !=# ''
    let l:instance.mod = l:opts.mod
  end

  let l:instance.origin = exists('*win_getid') ? win_getid() : 0
  call s:create_window(l:instance)
  call s:after_open(l:instance)

  if g:neoterm_autoscroll
    call l:instance.normal('G')
  end
endfunction

function! neoterm#close(opts)
  let l:instance = s:target(a:opts)

  if !empty(l:instance)
    let l:instance.origin = exists('*win_getid') ? win_getid() : 0

    try
      if a:opts.force || !g:neoterm_keep_term_open
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
      call neoterm#open(a:instance)
    end
  else
    call neoterm#new()
  end
endfunction

function! neoterm#do(command)
  let l:command = neoterm#expand_cmd(a:command)
  call neoterm#exec([l:command, g:neoterm_eof])
endfunction

function! neoterm#exec(command)
  if !g:neoterm.has_any() || g:neoterm_open_in_all_tabs
    call neoterm#open({})
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
