nmap <f4> :call OpenOtherFile()<cr>
au BufReadPost *.c call FindAndSetLocalTags()
set cindent
call LoadIfExists('cscope')
