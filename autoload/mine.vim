function mine#isGoTestFile()
  return match(expand('%:t'), '_test.go$') != -1
endfun

function mine#getSkeletonFile()
  let ext = expand('%:e')
  let base = ext
  if ext == 'go'
    if mine#isGoTestFile()
      let base = base . '_test'
    elseif ! mine#isGoMainFile()
      let base = base . '_package'
    endif
  endif
  let file = '~/.vim/skel/' . base . '.' . ext
  return file
endfun

function mine#injectSkeleton(fname)
  let file = mine#getSkeletonFile()
  if ! filereadable(expand(file))
    return
  endif

  echo "file " . file
  exe ':0r ' . file

  if search('BARENAME', 'cw') != 0
    let barename = substitute(a:fname, '\..*', '', '')
    exec '%s,\<BARENAME\>,' . barename . ',g'
  endif

  if search('PERLPACKAGE', 'cw') != 0
    let barename = substitute(a:fname, '\..*', '', '')
    let barename = substitute(barename, '\/', '::', '')
    exec '%s,\<PERLPACKAGE\>,' . barename . ',g'
  endif

  if match(a:fname, '.go$') != -1
    call mine#setupGo()
  endif

  normal Gdd
  if search('CURSORHERE', 'cw') != 0
    normal cw
  endif
endfun

func! mine#insertBracket()
	let funBracket = "{}O"
	let hashBracket = "{}i"
	let c = col('.')
	if c == 1
		return funBracket
	endif

	let line = getline('.')
	if &ft == "perl" && match(line, "^sub ") != -1
		return "{}Omy () = @_;F)i$"
	endif

	let charBefore = line[c-2]
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

function mine#deletePair()
  let boringDelete = ""
  let pairDelete = "x"

  let line = getline('.')
  let c = col('.')
  if len(line) < c
    return boringDelete
  endif

  let left = line[c-2]
  let right = line[c-1]
  if left == "'" && right == "'" ||
	\ left == "'" && right == "'" ||
	\ left == '(' && right == ')' ||
	\ left == '{' && right == '}' ||
	\ left == '[' && right == ']' ||
	\ left == '[' && right == ']'
    return pairDelete
  endif

  return boringDelete
endfun

let s:pairFor = { '"': '"', "'": "'", '(': ')', '[': ']' }
func! mine#insertPair(for)
  let c = col('.')
  let pair = a:for
  if c == 1
    return a:for . s:pairFor[ a:for ] . 'i'
  endif

  let synType = synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")
  if synType == 'Comment'
    return a:for
  endif

  let line = getline('.')
  if c < len(line)
    let nextChar = line[c]
    if nextChar >= 'a' && nextChar <= 'z' || nextChar >= 'A' && nextChar <= 'Z'
      return a:for
    endif
  endif

  if a:for == "'" && line[c-2] == 'n'
    " can't, don't, etc
    return "'"
  endif

  " Uncomment for debugging
  "return a:for . s:pairFor[ a:for ] . synType . 'i'
  return a:for . s:pairFor[ a:for ] . 'i'
endfun

function mine#hasToken(token)
  return search(a:token, 'cw') != 0
endfun

function mine#setGoPackage()
  if mine#isGoMainFile()
    let pkg = 'main'
  else
    let pkg = expand('%:p:h:t')
  endif
  exec '%s,\<GOPACKAGE\>,' . pkg . ',g'
endfun

function mine#isGoMainFile()
  return search('^func main(', 'cnw') != 0 ||
	\ match(expand('%:p'), '_test.go$') == -1 &&
	\ (
	\ match(expand('%:p'), '\/main.go') != -1 ||
	\ match(expand('%:p'), 'src\/[^/]\+$') != -1 ||
	\ match(expand('%:p'), '/cmd/') != -1 ||
	\ match(expand('%:p'), '\/a.go') != -1
	\ )
endfun

function mine#setupGo()
  if mine#hasToken('\<GOPACKAGE\>')
    call mine#setGoPackage()
  endif
endfu

function mine#setTmuxWindowName()
  if $SSH_CONNECTION != ""
    return
  endif
  let curr_title = system("tmux display-message -p '#W'")
  if v:shell_error
    return
  end
  if len(curr_title) > 0 && curr_title[0] == '*'
    return
  end

  let fname = expand("%:t")
  if len(fname) == 0
    let fname = "vim@" . substitute(getcwd(), $HOME, '\~', '')
  endif
  call system("tmux rename-window '" . fname . "'")
endfun
