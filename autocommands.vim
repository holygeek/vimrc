" Return cursor back to where it was if we reopen a recent file
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif 
au BufReadPost ~/.shell/* set ft=sh

au BufReadPost *.{[ch],ps,vim} call FindAndSetLocalTags()

au BufReadPost ~/.shell/opt.rc
\ set completefunc=CompleteZshOptions |

au BufReadPost blame.txt set ft=blame

fun! Foo()
  return 0
endfun
au BufReadPost ~/.shell/opt.rc
\ set completefunc=CompleteZshOptions |
\ let g:acp_behavior['*'][0]['command'] = '' |
\ let g:acp_behavior['*'][0]['completefunc'] = 'CompleteZshOptions' |
\ let g:acp_behavior['*'][0]['meets'] = 'len' |
\ let g:acp_behavior['*'][0]['onPopupClose'] = 'Foo' |
\ set keywordprg=zshoptions |
\ nunmap K

au BufReadPost ~/.shell/*.rc set ft=zsh
