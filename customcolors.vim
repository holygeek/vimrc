" Omni completion
hi Pmenu ctermfg=black ctermbg=darkgray
hi PmenuSel ctermfg=black ctermbg=gray
hi LineNr ctermfg=darkgray
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

hi MatchParen ctermbg=white ctermfg=black cterm=standout,underline

"syn match braces "[{}]"
"hi braces ctermfg=darkgray

if &diff
  so ~/.vim/diffcolor.vim
endif

let source_filetypes = [
 \ 'c',
 \ 'diff',
 \ 'java',
 \ 'javascript',
 \ 'perl',
 \ 'python',
 \ 'ruby',
 \ 'vim'
 \ ]
au BufReadPost * if &ft =~ '\v^('. join(source_filetypes, '|') . ')$'|call SetColumnBG()|endif
