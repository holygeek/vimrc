function mine#injectSkeleton(fname)
  let ext = expand('%:e')
  let file = '~/.vim/skel/' . ext . '.' . ext
  if filereadable(expand(file))
    echo "file " . file
    exe ':0r ' . file
    normal Gdd
    if search('CURSORHERE', 'cw') != 0
      normal cw
    endif
  endif
endfun
