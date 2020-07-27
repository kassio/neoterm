call vmtest#plugin('neoterm')
let g:vmtests.neoterm.args = { '_name': 'Args Test' }

function! g:vmtests.neoterm.args.test_with_valid_resize()
  call assert_equal(
        \ 10,
        \ neoterm#args#size('resize=10', 0)
        \ )
endfunction

function! g:vmtests.neoterm.args.test_with_invalid_resize()
  call assert_equal(
        \ 0,
        \ neoterm#args#size('resize=abc', 0)
        \ )
endfunction

function! g:vmtests.neoterm.args.test_use_default_when_no_resize()
  call assert_equal(
        \ 10,
        \ neoterm#args#size('', 10)
        \ )
endfunction

function! g:vmtests.neoterm.args.test_use_default_with_invalid_resize()
  call assert_equal(
        \ 10,
        \ neoterm#args#size('resize=abc', 10)
        \ )
endfunction
