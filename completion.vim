" control + t - complete text from terminals
inoremap <buffer> <c-t> <c-r>=TermsMatch()<cr>

function! TermsMatch()
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\S'
      let start -= 1
    endwhile
    let end = col('.')
    let base = line[ start : end ]
    let cmd = 'termsmatch -e ' . $TERM_NAME . ' -- ^' . base
    let matches = system(cmd)
    "let matches = split(matches, '\n')
    call complete(start + 1, split(matches, '\n'))
    return ''
endfun

fun! GetBaseColumnUpto(pattern)
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] != a:pattern
      let start -= 1
    endwhile
    return start
endfun

fun! ArrayFrom(cmd)
  return split(system(a:cmd), '\n')
endfun

fun! CompleteZshOptions(findstart, base)
  if a:findstart
    return GetBaseColumnUpto(' ')
  else
    " find zshoptions matching "^a:base"
    let cmd = "~/.vim/bin/zshoptions | grep -i '^" . a:base . "'"
    return ArrayFrom(cmd)
  endif
endfunction

