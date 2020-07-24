call vmtest#plugin('neoterm')
let g:vmtests.neoterm.origin = { '_name': 'Origin Test' }

function! g:vmtests.neoterm.origin._before()
  let self.original_win = s:current_win()
  let self.original_buffer = s:current_buffer()
  new
endfunction

function! g:vmtests.neoterm.origin._after()
  bd
endfunction

function! g:vmtests.neoterm.origin.test_new()
  call assert_equal(
        \ {'win_id': s:current_win(), 'last_buffer_id': self.original_buffer},
        \ neoterm#origin#new()
        \ )
endfunction

function! g:vmtests.neoterm.origin.return_to_buffer()
  call assert_notequal(self.original_buffer, s:current_buffer())

  call neoterm#origin#return({'last_buffer_id': self.original_buffer}, 'buffer')

  call assert_equal(self.original_buffer, s:current_buffer())
endfunction

function! g:vmtests.neoterm.origin.return_to_window()
  call assert_notequal(self.original_win, s:current_win())

  call neoterm#origin#return({'win_id': self.original_win})

  call assert_equal(self.original_win, s:current_win())
endfunction

function! g:vmtests.neoterm.origin.return_to_previous_window()
  call assert_notequal(self.original_win, s:current_win())

  call neoterm#origin#return({'win_id': 0})

  call assert_equal(self.original_win, s:current_win())
endfunction

function! s:current_buffer()
  return bufnr('%')
endfunction

function! s:current_win()
  return win_getid()
endfunction
