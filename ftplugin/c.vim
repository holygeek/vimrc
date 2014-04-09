nmap <f4> :call OpenOtherFile()<cr>
au BufReadPost *.c call FindAndSetLocalTags()
au BufReadPost * if &ft == 'qf'|exec '1;/ error: '|endif
set cindent
call LoadIfExists('cscope')
source ~/.vim/pairmap.vim
