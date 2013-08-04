function mine#injectSkeleton(fname)
  let ext = expand('%:e')
  let file = '~/.vim/skel/' . ext . '.' . ext
  if filereadable(expand(file))
    echo "file " . file
    exe ':0r ' . file

    if search('BARENAME', 'cw') != 0
      let barename = substitute(a:fname, '\..*', '', '')
      exec '%s/\<BARENAME\>/' . barename . '/g'
    endif

    normal Gdd
    if search('CURSORHERE', 'cw') != 0
      normal cw
    endif

  endif
endfun

func! mine#insertBracket()
	let funBracket = "{}O"
	let hashBracket = "{}i"
	let c = col('.')
	if c == 1
		return funBracket
	endif

	let charBefore = getline('.')[c-2]
	if charBefore == ' ' || charBefore == "\t"
		return funBracket
	endif
	return hashBracket
endfun

func! mine#insertSemicolon()
  let forSemicolon = ";"
  let statementSecolon = "A;"

  if mine#isForFor()
    return forSemicolon
  endif

  return statementSecolon
endfun

func! mine#isForFor()
	let c = col('.')
	let line = getline('.')
	let len = len(line)

	let l:i = c - 1
	while l:i > 0
	  if len - l:i < 3
	    let l:i = l:i - 1
	    continue
	  endif

	  if line[l:i] == 'f' &&
	    \ line[l:i+1] == 'o' &&
	    \ line[l:i+2] == 'r' && (line[l:i+3] == ' ' || line[l:i+3] == '(')
	      return 1
	  endif
	  let l:i = l:i - 1
	endwhile

	return 0
endfun
