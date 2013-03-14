function mine#injectSkeleton(fname)
  let ext = substitute(a:fname, '.*\.', '', '')
  let file = '~/.vim/skel/skel.' . ext
  if filereadable(expand(file))
    echo "file " . file
    exe ':0r ' . file
    if search('CURSORHERE', 'cw') != 0
      normal cw
    endif
  else
    echo "No skeleton for file '" . a:fname . "'"
  endif
endfun
