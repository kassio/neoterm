if (!has('nvim') && !has('terminal')) || get(g:, 'neoterm_loaded', 0)
  finish
endif

let g:neoterm_loaded = 1

let g:neoterm = {
      \ 'last_id': 0,
      \ 'last_active': 0,
      \ 'open': 0,
      \ 'instances': {}
      \ }

function! g:neoterm.next_id()
  let l:self.last_id += 1
  return l:self.last_id
endfunction

function! g:neoterm.has_any()
  return !empty(l:self.instances)
endfunction

function! g:neoterm.last()
  if l:self.has_any()
    if has_key(l:self.instances, l:self.last_active)
      return l:self.instances[l:self.last_active]
    else
      let l:keys = keys(g:neoterm.instances)
      return l:self.instances[l:keys[-1]]
    end
  end
endfunction

let g:neoterm_statusline = ''

if !exists('g:neoterm_shell')
  if has('nvim') && exists('&shellcmdflag')
    let g:neoterm_shell = &shell . ' ' . substitute(&shellcmdflag, '[-/]c', '', '')
  else
    let g:neoterm_shell = &shell
  end
end

if !exists('g:neoterm_size')
  let g:neoterm_size = ''
end

if !exists('g:neoterm_direct_open_repl')
  let g:neoterm_direct_open_repl = 0
end

if !exists('g:neoterm_automap_keys')
  let g:neoterm_automap_keys = ',tt'
end

if !exists('g:neoterm_keep_term_open')
  let g:neoterm_keep_term_open = 1
end

if !exists('g:neoterm_autoinsert')
  let g:neoterm_autoinsert = 0
end

if !exists('g:neoterm_autojump')
  let g:neoterm_autojump = 0
endif

if !exists('g:neoterm_default_mod')
  let g:neoterm_default_mod = ''
end

if !exists('g:neoterm_use_relative_path')
  let g:neoterm_use_relative_path = 0
end

if !exists('g:neoterm_repl_ruby')
  let g:neoterm_repl_ruby = 'irb'
end

if !exists('g:neoterm_repl_python')
  let g:neoterm_repl_python = ''
end

if !exists('g:neoterm_repl_octave_qt')
  let g:neoterm_repl_octave_qt = 0
end

if !exists('g:neoterm_repl_php')
  let g:neoterm_repl_php = ''
end

if !exists('g:neoterm_eof')
  let g:neoterm_eof = ''
end

if !exists('g:neoterm_autoscroll')
  let g:neoterm_autoscroll = 0
end

if !exists('g:neoterm_fixedsize')
  let g:neoterm_fixedsize = 0
end

if !exists('g:neoterm_open_in_all_tabs')
  let g:neoterm_open_in_all_tabs = 0
end

if !exists('g:neoterm_auto_repl_cmd')
  let g:neoterm_auto_repl_cmd = 1
end

if exists('g:neoterm_position')
  echoe '*g:neoterm_position* DEPRECATED! see :help g:neoterm_position'
end

if exists('g:neoterm_split_on_tnew')
  echoe '*g:neoterm_split_on_tnew* DEPRECATED! see :help g:neoterm_split_on_tnew'
end

if exists('g:neoterm_tnew_mod')
  echoe '*g:neoterm_tnew_mod* DEPRECATED! see :help g:neoterm_split_on_tnew'
end

" Handling
command! -range=0 -complete=shellcmd -nargs=+ T
      \ call neoterm#do({ 'cmd': <q-args>, 'target': <count>, 'mod': <q-mods> })
command! -range=0 -complete=shellcmd -nargs=+ Texec
      \ call neoterm#exec({ 'cmd': [<f-args>, ''], 'target': <count> })
command! -bar Tnew
      \ call neoterm#new({ 'mod': <q-mods> })
command! -bar -range=0 Topen
      \ call neoterm#open({ 'mod': <q-mods>, 'target': <count> })
command! -bar -bang -range=0 Tclose
      \ call neoterm#close({ 'force': <bang>0, 'target': <count> })
command! -bar -bang TcloseAll
      \ call neoterm#closeAll({ 'force': <bang>0 })
command! -bar -range=0 Ttoggle
      \ call neoterm#toggle({ 'mod': <q-mods>, 'target': <count> })
command! -bar TtoggleAll
      \ call neoterm#toggleAll()
command! -bar -range=0 Tclear
      \ call neoterm#clear({ 'target': <count> })
command! -bar -range=0 Tkill
      \ call neoterm#kill({ 'target': <count> })
command! -complete=shellcmd -nargs=+ Tmap
      \ call neoterm#map_for(<q-args>)
" Navigation
command! Tnext
      \ call neoterm#next()
command! Tprevious
      \ call neoterm#previous()
" REPL
command! -bar -complete=customlist,neoterm#list -nargs=1 TREPLSetTerm
      \ call neoterm#repl#term(<q-args>)
command! -range=% TREPLSendFile
      \ call neoterm#repl#line(<line1>, <line2>)
command! -range TREPLSendSelection
      \ call neoterm#repl#selection()
command! -range TREPLSendLine
      \ call neoterm#repl#line(<line1>, <line2>)
" REPL selection mappings
nnoremap <silent> <Plug>(neoterm-repl-send)
      \ :<c-u>set opfunc=neoterm#repl#opfunc<cr>g@
xnoremap <silent> <Plug>(neoterm-repl-send)
      \ :<c-u>call neoterm#repl#selection()<cr>
nnoremap <silent> <Plug>(neoterm-repl-send-line)
      \ :<c-u>set opfunc=neoterm#repl#opfunc<bar>exe 'norm! 'v:count1.'g@_'<cr>
