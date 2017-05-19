" Return cursor back to where it was if we reopen a recent file
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif 

au BufReadPost * if &ft != 'qf'|exec "nnoremap <buffer> <cr> :nohl<cr>:set invlist<cr>"|endif

au BufReadPost ~/.shell/* set ft=sh

au BufReadPost *.{[ch],ps,vim} call FindAndSetLocalTags()

au BufReadPost ~/.shell/opt.rc
\ set completefunc=CompleteZshOptions |

au BufReadPost /usr/share/doc/rpm/*
\ syn match hide "\\\(end\)\?\(section \?\|verbatim\)" conceal |
\ set conceallevel=2

au BufReadPost blame.txt set ft=blame
au BufReadPost *.gcov set ft=gcov

fun! DoNothing()
  return 0
endfun
au BufReadPost ~/.shell/opt.rc
\ set completefunc=CompleteZshOptions |
\ let g:acp_behavior['*'][0]['command'] = '' |
\ let g:acp_behavior['*'][0]['completefunc'] = 'CompleteZshOptions' |
\ let g:acp_behavior['*'][0]['meets'] = 'len' |
\ let g:acp_behavior['*'][0]['onPopupClose'] = 'DoNothing' |
\ set keywordprg=zshoptions |
\ nunmap K

au BufReadPost ~/.shell/*.rc set ft=zsh

let noeighties = [
 \ 'text',
 \ ]
au BufReadPost,VimResized *.pl,*.pm
      \ if len(&ft) && &ft !~ '\v^('. join(noeighties, '|') . ')$'|call SetColumnBG()|endif

au BufNewFile * call mine#injectSkeleton(expand('<afile>'))

au BufWritePost * if len(&filetype) == 0|filetype detect|end

au BufEnter t.pl nmap <buffer> <F8> :w:!perl %

au BufRead ~/sig/sig set syntax=signatures tw=70 fo+=n
au BufWritePost ~/sig/sig execute "normal :!/usr/bin/strfile -r ~/sig/sig"
autocmd WinEnter,BufEnter * call mine#setTmuxWindowName()
"autocmd WinEnter,BufEnter,CursorHold * call mine#setTmuxWindowName()

au BufRead *.go set sw=8 sts=8 ts=8
au BufWritePost *.go set sw=8 sts=8 ts=8
