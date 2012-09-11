" Omni completion
hi Pmenu ctermfg=black ctermbg=darkgray
hi PmenuSel ctermfg=black ctermbg=gray
hi LineNr ctermfg=darkgray

hi folded ctermfg=darkgray ctermbg=black
"  guifg=gray guibg=black

hi MatchParen ctermbg=white ctermfg=black cterm=standout,underline

"syn match braces "[{}]"
"hi braces ctermfg=darkgray

if &diff
  so ~/.vim/diffcolor.vim
endif
