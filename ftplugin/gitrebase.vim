nnoremap <buffer><silent> <F7> :g/^\(pick\\|fixup\) /ShowPickNote<cr>:nohl<cr>

function! ShowPickNote(l1, l2, filepattern)
	if a:l1 != a:l2
		echoerr "ShowPickNote: l1 and l2 are different? l1: " . a:l1 . ", l2: " . a:l2
		return
	endif
	let pickline = getline(a:l1)
	let mlist = matchlist(pickline, '^\(pick\|fixup\) \([a-z0-9]\+\) ')
	if len(mlist) <= 2
		echoerr "ShowPickNote: line " . a:l1 . " does not match ^(pick|fixup) sha1"
		return
	endif
	let sha1 = mlist[2]
	let picknote_args = sha1
	if a:filepattern != ""
		let picknote_args = "-f " . a:filepattern . " " . picknote_args
	endif

	exec "r!git picknote " . picknote_args
endfun

command! -range -nargs=? ShowPickNote call ShowPickNote(<line1>, <line2>, <q-args>)

syn match picknote '^   #.*'
hi link picknote comment
