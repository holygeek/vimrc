syn match fileline '[A-z0-9_/.-]\+:[0-9]\+\(:[0-9]\+\)\?:'
syn region      plainString start=+"+ skip=+\\\\\|\\"+ end=+"+

syn match checklog_annotation '  <- .*$'
hi checklog_annotation guifg=green

hi fileline guifg=#b1b9f9
hi link plainString constant
