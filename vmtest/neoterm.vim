call vmtest#plugin('neoterm')
let g:vmtests.neoterm.neoterm = { '_name': 'g:neoterm tests' }

function! g:vmtests.neoterm.neoterm.test_when_theres_no_instances()
  call assert_equal(
        \ 1,
        \ neoterm#next_id([], 0)
        \ )
endfunction

function! g:vmtests.neoterm.neoterm.test_when_theres_sequential_instances()
  call assert_equal(
        \ 4,
        \ neoterm#next_id([1, 2, 3], 3)
        \ )
endfunction

function! g:vmtests.neoterm.neoterm.test_when_instances_are_not_sequential()
  call assert_equal(
        \ 2,
        \ neoterm#next_id([1, 3], 3)
        \ )
endfunction
