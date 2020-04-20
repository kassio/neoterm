" Creates a new neoterm instance.
"
" Params: Optional dictionary with the optional keys:
"        mod: Which could be one of vim mods (`:help mods`).
"        handlers: Dictionary with `on_stdout`, `on_stderr` and/or `on_exit`.
"                   On vim these will be renamed to `out_cb`, `err_cb`,
"                   `exit_cb`. For more info read `:help job_control.txt`
"        from_event: Set when the neoterm is being created from the TermOpen
"        event. This enables neoterm to manage every term created on neovim.
function! neoterm#new(...) abort
  let l:opts = extend(get(a:, 1, {}), {
        \ 'handlers': {},
        \ 'mod': '',
        \ 'buffer_id': 0,
        \ 'origin': neoterm#origin#new(),
        \ 'from_event': 0,
        \ }, 'keep')

  let l:instance = extend(copy(g:neoterm.prototype), l:opts)

  if !l:opts.from_event
    call s:create_window(l:instance)
  end

  let l:instance.buffer_id = bufnr('')
  let l:instance.id = g:neoterm.next_id()
  let l:instance.name = printf('neoterm-%s', l:instance.id)
  let t:neoterm_id = l:instance.id

  if l:opts.from_event
    let l:instance.termid = g:neoterm.get_current_termid()
  else
    let l:instance.termid = g:neoterm.new(l:instance)
  end

  let g:neoterm.managed += [l:instance.termid]

  call s:after_open(l:instance)

  let g:neoterm.instances[l:instance.id] = l:instance

  call s:update_last_active(l:opts, l:instance)

  return l:instance
endfunction

function! neoterm#new_from_event() abort
  let l:should_load = get(g:, 'SessionLoad', 0)
        \ && index(g:neoterm.managed, g:neoterm.get_current_termid()) < 0

  if l:should_load
    call neoterm#new({'from_event': 1})
  end
endfunction

function! neoterm#open(...) abort
  let l:opts = extend(a:1, { 'mod': '', 'target': 0 }, 'keep')
  let l:instance = neoterm#target#get(l:opts)

  if empty(l:instance)
    call neoterm#new({ 'mod': l:opts.mod, 'update_last_active': v:true })
  elseif bufwinnr(l:instance.buffer_id) == -1
    if l:opts.mod !=# ''
      let l:instance.mod = l:opts.mod
    end

    let l:instance.origin = neoterm#origin#new()
    call s:create_window(l:instance)
    call s:after_open(l:instance)

    let g:neoterm.last_active = l:instance.id
    if g:neoterm_autoscroll
      call l:instance.normal('G')
    end
  end
endfunction

function! neoterm#close(...) abort
  let l:opts = extend(a:1, { 'target': 0, 'force': 0 }, 'keep')
  let l:instance = neoterm#target#get(l:opts)

  if !empty(l:instance)
    let l:instance.origin = neoterm#origin#new()

    try
      if l:opts.force || !g:neoterm_keep_term_open
        exec printf('%sbdelete!', l:instance.buffer_id)
      else
        exec printf('%shide', bufwinnr(l:instance.buffer_id))
      end

      call neoterm#origin#return(l:instance.origin)
    catch /^Vim\%((\a\+)\)\=:E444/
      if len(getbufinfo()) == 1
        echoe 'neoterm is the only opened window. To close it use `:Tclose!`'
      end

      call neoterm#origin#return(l:instance.origin, 'buffer')
    endtry
  end
endfunction

function! neoterm#closeAll(...) abort
  for l:instance in values(g:neoterm.instances)
    call neoterm#close(extend(a:1, { 'target': l:instance.id }))
  endfor
endfunction

function! s:after_open(instance) abort
  let b:neoterm_id = a:instance.id
  let b:term_title = a:instance.name
  setf neoterm
  setlocal nonumber norelativenumber signcolumn=auto

  if g:neoterm_fixedsize
    setlocal winfixheight winfixwidth
  end

  if g:neoterm_keep_term_open
    setlocal bufhidden=hide
  end

  if g:neoterm_autoinsert
    startinsert
  elseif !g:neoterm_autojump
    call neoterm#origin#return(a:instance.origin)
  end
endfunction

function! neoterm#toggle(...) abort
  let l:opts = extend(a:1, { 'mod': '', 'target': 0 }, 'keep')
  let l:instance = neoterm#target#get(l:opts)

  if empty(l:instance)
    call neoterm#new({ 'mod': l:opts.mod, 'update_last_active': v:true })
  else
    call s:update_last_active({ 'update_last_active': v:true}, l:instance)

    if bufwinnr(l:instance.buffer_id) > 0
      call neoterm#close(l:opts)
    else
      call neoterm#open(l:opts)
    end
  end
endfunction

function! neoterm#toggleAll() abort
  for l:id in keys(g:neoterm.instances)
    call neoterm#toggle({ 'target': l:id })
  endfor
endfunction

function! neoterm#do(opts) abort
  let l:opts = extend(a:opts, { 'mod': '', 'target': 0 }, 'keep')
  let l:opts.cmd = [l:opts.cmd, g:neoterm_eof]
  call neoterm#exec(l:opts)
endfunction

function! neoterm#exec(opts) abort
  let l:opts = extend(a:opts, { 'update_last_active': v:true }, 'keep')
  let l:command = map(copy(l:opts.cmd), { i, cmd -> s:expand(cmd) })
  let l:instance = neoterm#target#get({ 'target': get(l:opts, 'target', 0) })

  if s:requires_new_instance(l:instance)
    let l:instance = neoterm#new({ 'mod': get(l:opts, 'mod', '') })
  end

  if !empty(l:instance)
    call s:update_last_active(l:opts, l:instance)
    call l:instance.exec(l:command)

    if get(l:opts, 'force_clear', 0)
      let l:bufname = bufname(l:instance.buffer_id)
      let l:scrollback = getbufvar(l:bufname, '&scrollback')

      call setbufvar(l:bufname, '&scrollback', 1)
      sleep 100m
      call setbufvar(l:bufname, '&scrollback', l:scrollback)
    end
  end
endfunction

function! s:requires_new_instance(instance) abort
  return
        \ (
        \   empty(a:instance) &&
        \   g:neoterm_term_per_tab &&
        \   !has_key(t:, 'neoterm_id')
        \ ) || (
        \   empty(a:instance) &&
        \   !g:neoterm.has_any()
        \ )
endfunction

function! neoterm#map_for(...) abort
  let g:neoterm.map_options = extend(a:1, {
        \ 'target': 0,
        \ 'update_last_active': v:false
        \ }, 'keep')
endfunction

function! neoterm#map_do() abort
  call neoterm#do(copy(g:neoterm.map_options))
endfunction

function! neoterm#clear(...) abort
  call neoterm#exec(extend(a:1, {
        \ 'cmd': g:neoterm_clear_cmd,
        \ 'force_clear': 0
        \ }, 'keep'))
endfunction

function! neoterm#kill(...) abort
  call neoterm#exec(extend(a:1, { 'cmd': ["\<c-c>"] }))
endfunction

function! neoterm#normal(cmd) abort
  silent call g:neoterm.last().normal(a:cmd)
endfunction

function! neoterm#vim_exec(cmd) abort
  silent call g:neoterm.last().vim_exec(a:cmd)
endfunction

function! neoterm#list(arg_lead, cmd_line, cursor_pos) abort
  return filter(keys(g:neoterm.instances), 'v:val =~? "'. a:arg_lead. '"')
endfunction

function! neoterm#next() abort
  function! s:next(ids, index) abort
    let l:next_index = a:index +1
    return l:next_index > (len(a:ids) - 1) ? 0 : l:next_index
  endfunction

  call s:navigate_with(function('s:next'))
endfunction

function! neoterm#previous() abort
  call s:navigate_with({ _, i -> i - 1 })
endfunction

function! neoterm#destroy(instance) abort
  if has_key(g:neoterm, 'repl') && get(g:neoterm.repl, 'instance_id') ==# a:instance.id
    call remove(g:neoterm.repl, 'instance_id')
  end

  if has_key(g:neoterm.instances, a:instance.id)
    if bufexists(a:instance.buffer_id)
      exec printf('%sbdelete!', a:instance.buffer_id)
    end
    call remove(g:neoterm.instances, a:instance.id)
  end

  if has_key(t:, 'neoterm_id')
    unlet! t:neoterm_id
  end

  if g:neoterm.last_active == a:instance.id
    let g:neoterm.last_active = 0
  end
endfunction

function! neoterm#list_ids() abort
      echom 'Open neoterm ids:'
      for id in keys(g:neoterm.instances)
        echom printf('ID: %s | name: %s | bufnr: %s',
              \ id,
              \ g:neoterm.instances[id].name,
              \ g:neoterm.instances[id].buffer_id)
      endfor
endfunction

function! s:create_window(instance) abort
  let l:mod = a:instance.mod !=# '' ? a:instance.mod : g:neoterm_default_mod

  if l:mod !=# ''
    let l:hidden=&hidden
    let &hidden=0

    let l:cmd = printf('%s %snew', l:mod, g:neoterm_size)
    if a:instance.buffer_id > 0
      let l:cmd .= printf(' +buffer%s', a:instance.buffer_id)
    end

    exec l:cmd

    if !empty(g:neoterm_size)
      exec printf('%s resize %s', l:mod, g:neoterm_size)
    endif

    let &hidden=l:hidden
  else
    enew
  end

  if get(a:instance, 'buffer_id', 0) > 0 && bufnr('') != a:instance.buffer_id
    exec printf('buffer %s', a:instance.buffer_id)
  end
endfunction

function! s:navigate_with(callback) abort
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

function! s:expand(command) abort
  let l:command = substitute(a:command, '[^\\]\zs%\(:[phtre]\)\+', '\=expand(submatch(0))', 'g')
  let l:command = substitute(l:command, '\c\\<cr>', g:neoterm_eof, 'g')
  let l:path = g:neoterm_use_relative_path ? expand('%') : expand('%:p')

  let l:command = substitute(l:command, '[^\\]\zs%', l:path, 'g')
  let l:command = substitute(l:command, '\\%', '%', 'g')

  return l:command
endfunction

function! s:update_last_active(opts, instance) abort
  if get(a:opts, 'update_last_active', v:false)
    let g:neoterm.last_active = a:instance.id
  end
endfunction
