if has("cscope")
  "set csprg=/usr/local/bin/cscope
  set csprg=/usr/bin/cscope
  set csto=0
  set cst
  set nocsverb
  " See :help csqf
  set cscopequickfix=s-,c-,d-,i-,t-,e-
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
  " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set csverb
endif

