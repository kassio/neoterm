set confirm
let Shell = {}

function Shell.on_stdout(job_id, data)
  call append(line('$'), 'OUT: '.join(a:data))
endfunction

function Shell.on_stderr(job_id, data)
  call append(line('$'), 'ERR: '.join(a:data))
endfunction

function Shell.on_exit(job_id, data)
  call append(line('$'), 'exited: '.a:data)
endfunction

function Shell.get_name()
  return 'shell '.self.name
endfunction

function Shell.new(name, ...)
  let instance = extend(copy(g:Shell), {'name': a:name})
  let argv = ['bash']
  if a:0 > 0
    let argv += ['-c', a:1]
  endif
  new
  let instance.id = jobstart(argv, instance)
  return instance
endfunction

function! BufDo(command)
  let currBuff=bufnr("%")
  execute 'bufdo ' . a:command
  execute 'buffer ' . currBuff
endfunction

let s1 = Shell.new('1', 'rake')
" let s2 = Shell.new('2', 'for i in {1..10}; do a; echo hello $i!; done')
"
" function! s:JobHandler(job_id, data, event)
"   echom a:event.': '.string(a:data)
" endfunction
" let s:callbacks = {
"       \ 'on_stdout': function('s:JobHandler'),
"       \ 'on_stderr': function('s:JobHandler')
"       \ }
"
" new | call termopen([&sh, &shcf, 'echo "STDOUT"'], s:callbacks)
" new | call termopen([&sh, &shcf, 'BOOM'], s:callbacks)
