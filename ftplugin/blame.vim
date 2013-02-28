nnoremap <buffer> <enter> :call ShowGitCommit(line("."))<CR>
function! ShowGitCommit(lnum)
	if expand('%:t') == 'blame.txt'
		wincmd l
	endif
	let filename = expand('%')
        wincmd h
        exec ':' . a:lnum
	normal 0^lyiw
	wincmd l
	let sha1 = getreg('"')
	exec "top new +0r!git\\ show\\ -p\\ " . sha1 . "\\ " . $orig_filename
	" This does not trigger hlsearch??? whomod works fine!?
	exec "let @/='" . sha1 . "'"
	set buftype=nofile
        "set noscb " buftype=nofile
	normal gg
	set ft=diff
        "match Search /^Rc/
        "normal gg/^Rc
endfun
