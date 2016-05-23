function! neoterm#test#golang#run(scope)
  let command = 'go test'

  if a:scope == 'all'
    let command .= ' ./...'
  elseif a:scope == 'file'
    let command .= ' ./$(dirname $file)'
  elseif a:scope == 'current'
    " Sameway to find the function name as in vim-go's :GoTestFunc
    let linenum = search("^func", "bcnW")
    if linenum == 0
      let msg = '"neoterm: [golang] failed to find current function"'
      echo msg
      return "echo " . msg
    end
    let line = getline(linenum)
    let name = split(split(line, " ")[1], "(")[0]
    let command .= ' -run=Test' . name
  endif

  return command
endfunction
