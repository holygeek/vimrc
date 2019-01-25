set termguicolors
" Omni completion
"hi Search ctermbg=33
"hi Search ctermbg=brown ctermfg=white
"hi Search ctermbg=17 ctermfg=white
hi Search ctermbg=110 ctermfg=black
hi Pmenu ctermfg=black ctermbg=darkgray guifg=dimgray
hi PmenuSel ctermfg=black ctermbg=gray guifg=gray
"hi LineNr ctermfg=darkgray guifg=dimgray
"hi LineNr ctermfg=248 ctermbg=18
"hi LineNr ctermbg=233 ctermfg=darkgray
hi LineNr ctermbg=0 ctermfg=darkgray guifg=dimgray
"hi CursorLineNr ctermbg=brown ctermfg=black
hi CursorLineNr ctermbg=235 ctermfg=brown guifg=brown
hi comment ctermfg=110 guifg=#80a0d0
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

hi SignColumn ctermbg=black guibg=NONE

"syn match braces "[{}]"
"hi braces ctermfg=darkgray

so ~/.vim/diffcolor.vim

hi StatusLine term=reverse ctermfg=blue ctermbg=black
hi StatusLineNC ctermfg=darkgray ctermbg=black
hi NonText ctermfg=darkgray

if g:BG == 'white'
    source ~/.vim/lightcolors.vim
endif

hi TabLineFill cterm=none
hi TabLine ctermbg=none
