nmap <f4> :call OpenOtherFile()<cr>
au BufReadPost *.c call FindAndSetLocalTags()
set cindent spell
call LoadIfExists('cscope')
" hi SpellBad ctermfg=brown ctermbg=none
" hi spellbad cterm=bold ctermfg=110 guifg=#87afd7
