function! neoterm#repl#elixir#exec(command) abort
	let JoinNewLinePipes = luaeval('require("newlinepipejoiner").join_newline_pipes')
	let l:cmd = JoinNewLinePipes(a:command)
	call g:neoterm.repl.instance().exec(add(l:cmd, g:neoterm_eof))
endfunction
