" Omni completion
"hi Search ctermbg=33
"hi Search ctermbg=brown ctermfg=white
"hi Search ctermbg=17 ctermfg=white
hi Search ctermbg=110 ctermfg=black
hi Pmenu ctermfg=black ctermbg=darkgray guifg=darkgray
hi PmenuSel ctermfg=black ctermbg=gray guifg=gray
hi LineNr ctermfg=darkgray guifg=darkgray
hi CursorLineNr ctermfg=brown
hi comment ctermfg=110
"hi comment ctermfg=darkgray
"hi comment ctermfg=60
"hi comment ctermfg=116

" Color tryouts:
":nmap j :exec ':hi comment ctermfg=' . (K + 1) . "\|let K = K + 1\|echo
"K"<CR>
":nmap k :exec ':hi comment ctermfg=' . (K - 1) . "\|let K = K - 1\|echo
"K"<CR>

hi folded ctermfg=darkgray ctermbg=black
"  guifg=gray guibg=black

hi MatchParen cterm=underline ctermbg=none

hi SpellBad ctermfg=red ctermbg=none

hi SignColumn ctermbg=black guibg=none

"syn match braces "[{}]"
"hi braces ctermfg=darkgray

so ~/.vim/diffcolor.vim

hi StatusLine term=reverse ctermfg=blue ctermbg=black
hi StatusLineNC ctermfg=darkgray ctermbg=black
hi NonText ctermfg=darkgray

if $BG == 'white'
    source ~/.vim/lightcolors.vim
endif
