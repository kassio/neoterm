" Creates a new neoterm instance.
"
" Params: Optional dictionary with the optional keys:
"        mod: Which could be one of vim mods (`:help mods`).
"        handlers: Dictionary with `on_stdout`, `on_stderr` and/or `on_exit`.
"                   On vim these will be renamed to `out_cb`, `err_cb`,
"                   `exit_cb`. For more info read `:help job_control.txt`
function! neoterm#new(...)
  call neoterm#term#load()

  let l:opts = extend(get(a:, 1, {}), {
        \ 'handlers': {},
        \ 'mod': '',
        \ 'buffer_id': 0,
        \ 'origin': s:winid()
        \ }, 'keep')

  let l:instance = extend(copy(g:neoterm.prototype), l:opts)
  call s:create_window(l:instance)

  let l:instance.id = g:neoterm.next_id()
  let l:instance.name = printf('neoterm-%s', l:instance.id)
  let l:instance.termid = g:neoterm.new(l:instance)
  let l:instance.buffer_id = bufnr('')

  call s:after_open(l:instance)

  let g:neoterm.instances[l:instance.id] = l:instance

  return l:instance
endfunction

function! neoterm#open(...)
  let l:opts = extend(a:1, { 'mod': '', 'target': 0 }, 'keep')
  let l:instance = s:target(l:opts)

  if empty(l:instance)
    call neoterm#new({ 'mod': l:opts.mod })
    let g:neoterm.last_active = g:neoterm.last_id
  elseif bufwinnr(l:instance.buffer_id) == -1
    if l:opts.mod !=# ''
      let l:instance.mod = l:opts.mod
    end

    let l:instance.origin = s:winid()
    call s:create_window(l:instance)
    call s:after_open(l:instance)

    let g:neoterm.last_active = l:instance.id
    if g:neoterm_autoscroll
      call l:instance.normal('G')
    end
  end
endfunction

function! neoterm#close(...)
  let l:opts = extend(a:1, { 'target': 0, 'force': 0 }, 'keep')
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

function! neoterm#closeAll(...)
  for l:instance in values(g:neoterm.instances)
    call neoterm#close(extend(a:1, { 'target': l:instance.id }))
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

function! neoterm#toggle(...)
  let l:opts = extend(a:1, { 'mod': '', 'target': 0 }, 'keep')
  let l:instance = s:target(l:opts)

  if empty(l:instance)
    call neoterm#new({ 'mod': l:opts.mod })
  else
    if bufwinnr(l:instance.buffer_id) > 0
      call neoterm#close(l:opts)
    else
      call neoterm#open(l:opts)
    end
  end
endfunction

function! neoterm#toggleAll()
  for l:id in keys(g:neoterm.instances)
    call neoterm#toggle({ 'target': l:id })
  endfor
endfunction

function! neoterm#do(opts)
  let l:opts = extend(a:opts, { 'mod': '', 'target': 0 }, 'keep')
  let l:opts.cmd = [l:opts.cmd, g:neoterm_eof]
  call neoterm#exec(l:opts)
endfunction

function! neoterm#exec(opts)
  let l:command = map(copy(a:opts.cmd), { i, cmd -> s:expand(cmd) })
  let l:instance = s:target({ 'target': get(a:opts, 'target', 0) })

  if empty(l:instance) && !g:neoterm.has_any()
    let l:instance = neoterm#new({ 'mod': get(a:opts, 'mod', '') })
  end

  let g:neoterm.last_active = l:instance.id
  call l:instance.exec(l:command)
endfunction

function! neoterm#map_for(command)
  exec 'nnoremap <silent> '
        \ . g:neoterm_automap_keys .
        \ ' :T ' . s:expand(a:command) . '<cr>'
endfunction

function! neoterm#clear(...)
  call neoterm#exec(extend(a:1, { 'cmd': ["\<c-l>"] }))
endfunction

function! neoterm#kill(...)
  call neoterm#exec(extend(a:1, { 'cmd': ["\<c-c>"] }))
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
  function! s:next(ids, index)
    let l:next_index = a:index +1
    return l:next_index > (len(a:ids) - 1) ? 0 : l:next_index
  endfunction

  call s:navigate_with(function('s:next'))
endfunction

function! neoterm#previous()
  call s:navigate_with({ _, i -> i - 1 })
endfunction

function! neoterm#destroy(instance)
  if has_key(g:neoterm, 'repl') && get(g:neoterm.repl, 'instance_id') ==# a:instance.id
    call remove(g:neoterm.repl, 'instance_id')
  end

  if has_key(g:neoterm.instances, a:instance.id)
    if bufexists(a:instance.buffer_id)
      exec printf('%sbdelete!', a:instance.buffer_id)
    end
    call remove(g:neoterm.instances, a:instance.id)
  end

  if g:neoterm.last_active == a:instance.id
    let g:neoterm.last_active = 0
  end
endfunction

function! s:create_window(instance)
  let l:mod = a:instance.mod !=# '' ? a:instance.mod : g:neoterm_default_mod

  if l:mod !=# ''
    let l:hidden=&hidden
    let &hidden=0

    let l:cmd = printf('%s %snew', l:mod, g:neoterm_size)
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
      echoe printf('neoterm-%s not found', a:opts.target)
    end
  elseif g:neoterm.has_any()
    return g:neoterm.last()
  else
    return {}
  end
endfunction

function! s:navigate_with(callback)
  if &buftype ==? 'terminal'
    if len(g:neoterm.instances) > 1
      let l:ids = keys(g:neoterm.instances)
      let l:current_index = index(l:ids, string(b:neoterm_id))
      let l:id = l:ids[a:callback(l:ids, l:current_index)]
      let g:neoterm.last_active = l:id

      let l:hidden = &hidden
      set hidden
      exec printf('%sbuffer', g:neoterm.instances[l:id].buffer_id)
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
  let l:command = substitute(l:command, '\c\\<cr>', g:neoterm_eof, 'g')
  let l:path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')

  return substitute(l:command, '%', l:path, 'g')
endfunction
