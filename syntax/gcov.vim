if exists("b:current_syntax")
  finish
endif

set isk+=#
syn keyword noCoverageMarker ##### contained
syn match unCoveredLine "^ *#####:.*" contains=noCoverageMarker
hi noCoverageMarker ctermfg=red
hi unCoveredLine ctermfg=blue
