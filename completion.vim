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

