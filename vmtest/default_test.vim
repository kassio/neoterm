call vmtest#plugin('neoterm')
let g:vmtests.neoterm.default = { '_name': 'Default Options Test' }

function! g:vmtests.neoterm.default.test_with_no_given_opts()
  call assert_equal({
        \ 'handlers': {},
        \ 'mod': '',
        \ 'args': '',
        \ 'buffer_id': 0,
        \ 'from_session': v:false,
        \ 'origin': neoterm#origin#new(),
        \ 'shell': g:neoterm_shell
        \ },
        \ neoterm#default#opts({})
        \ )
endfunction

function! g:vmtests.neoterm.default.test_overwrite_default_values_with_given_opts()
  call assert_equal('vertical', neoterm#default#opts({ 'mod': 'vertical' }).mod)
endfunction

function! g:vmtests.neoterm.default.test_create_new_opts_with_given_values()
  call assert_equal('value', neoterm#default#opts({ 'new_key': 'value' }).new_key)
endfunction
