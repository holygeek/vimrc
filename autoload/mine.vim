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
