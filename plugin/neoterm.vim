if !has('nvim') || get(g:, 'neoterm_loaded', 0)
  finish
endif

let g:neoterm_loaded = 1

let g:neoterm = {
      \ 'last_id': 0,
      \ 'open': 0,
      \ 'instances': {}
      \ }

function! g:neoterm.next_id()
  let l:self.last_id += 1
  return l:self.last_id
endfunction

function! g:neoterm.has_any()
  return len(l:self.instances) > 0 && l:self.last_id > 0
endfunction

function! g:neoterm.last()
  if l:self.has_any()
    return l:self.instances[l:self.last_id]
  end
endfunction

let g:neoterm_statusline = ''

if !exists('g:neoterm_shell')
  if exists('&shellcmdflag')
    let g:neoterm_shell = &shell . ' ' . substitute(&shellcmdflag, '[-/]c', '', '')
  else
    let g:neoterm_shell = &shell
  end
end

if !exists('g:neoterm_size')
  let g:neoterm_size = ''
end

if !exists('g:neoterm_position')
  let g:neoterm_position = 'horizontal'
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

if exists('g:neoterm_split_on_tnew')
  echoe '*g:neoterm_split_on_tnew* DEPRECATED! see :help g:neoterm_split_on_tnew'
end

if !exists('g:neoterm_tnew_mod')
  let g:neoterm_tnew_mod = ''
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

command! -bar Tnew call neoterm#new({ 'source': 'tnew', 'mod': <q-mods> })
command! -bar -count Topen call neoterm#open({ 'mod': <q-mods>, 'target': <count> })
command! -bar -bang -count Tclose call neoterm#close({ 'force': <bang>0, 'target': <count> })
command! -bar -bang TcloseAll call neoterm#closeAll({ 'force': <bang>0 })
command! -bar -count Ttoggle call neoterm#toggle({ 'target': <count> })
command! -bar TtoggleAll call neoterm#toggleAll()
command! -complete=shellcmd -nargs=+ T call neoterm#do(<q-args>)
command! -complete=shellcmd -nargs=+ Tmap call neoterm#map_for(<q-args>)
command! -nargs=1 Tpos let g:neoterm_position=<q-args>

command! Tnext call neoterm#next()
command! Tprevious call neoterm#previous()

command! -bar -complete=customlist,neoterm#list -nargs=1 TREPLSetTerm call neoterm#repl#term(<q-args>)
command! -range=% TREPLSendFile call neoterm#repl#line(<line1>, <line2>)
command! -range TREPLSendSelection call neoterm#repl#selection()
command! -range TREPLSendLine call neoterm#repl#line(<line1>, <line2>)

nnoremap <silent> <Plug>(neoterm-repl-send) :<c-u>set opfunc=neoterm#repl#opfunc<cr>g@
xnoremap <silent> <Plug>(neoterm-repl-send) :<c-u>call neoterm#repl#selection()<cr>
nnoremap <silent> <Plug>(neoterm-repl-send-line) :<c-u>set opfunc=neoterm#repl#opfunc<bar>exe 'norm! 'v:count1.'g@_'<cr>
