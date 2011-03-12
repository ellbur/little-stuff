
fun! SE()
	execute("normal g<End>")
	if col('$') != 1
		execute("normal g<Right>")
	endif
endfun

noremap <silent> 2 i<End><Right><ESC>

