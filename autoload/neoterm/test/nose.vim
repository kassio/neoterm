function! neoterm#test#nose#run(scope)
  let command = 'nosetests'
  if a:scope == 'file'
    let command .= ' ' . expand('%:p')
  elseif a:scope == 'current'
python << endPython
import re
import vim

current_line_index = vim.current.window.cursor[0]
current_buffer = vim.current.buffer
file_name = vim.current.buffer.name

class_regex, class_name = re.compile(r"^class (?P<class_name>.+)\("), False
method_regex, method_name = re.compile(r"def (?P<method_name>.+)\("), False
for line in xrange(current_line_index - 1, -1, -1):
    if class_regex.search(current_buffer[line]) is not None and not class_name:
        class_name = class_regex.search(current_buffer[line])
        class_name = class_name.group(1)
    if method_regex.search(current_buffer[line]) is not None and not method_name and not class_name:
        method_name = method_regex.search(current_buffer[line])
        method_name = method_name.group(1)
vim.command('let command .= \' {}:{}.{}\''.format(file_name, class_name, method_name))

endPython
  endif

  echo command
  return command
endfunction
