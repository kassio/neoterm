let s:not_found_msg = 'neoterm-%s not found (probably already closed)'

function! neoterm#target#get(opts)
  if a:opts.target > 0
    return s:given_target(a:opts.target)
  elseif g:neoterm_term_per_tab
    return s:target_per_tab()
  elseif g:neoterm.has_any()
    return s:ensure_instance(g:neoterm.last())
  else
    return {}
  end
endfunction

function! s:given_target(target)
  if has_key(g:neoterm.instances, a:target)
    return s:ensure_instance(g:neoterm.instances[a:target])
  else
    echo printf(s:not_found_msg, a:target)
    return {}
  end
endfunction

function! s:target_per_tab()
  if has_key(t:, 'neoterm_id') && has_key(g:neoterm.instances, t:neoterm_id)
    return s:ensure_instance(g:neoterm.instances[t:neoterm_id])
  elseif !has_key(t:, 'neoterm_id')
    return {}
  else
    echo printf(s:not_found_msg, t:neoterm_id)
    return {}
  end
endfunction

function! s:ensure_instance(instance)
  if bufexists(a:instance.buffer_id)
    return a:instance
  else
    echo printf(s:not_found_msg, a:instance.id)
    call neoterm#destroy(a:instance)
    return {}
  end
endfunction
