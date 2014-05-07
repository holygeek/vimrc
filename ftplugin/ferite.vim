source ~/.vim/pairmap.vim
nmap <buffer> [[ :set nohlsearch<CR>?\(function\\|class\\|namespace\)\s<CR>:let @/ = ''\|set hlsearch<CR>
nmap <buffer> ]] :set nohlsearch<CR>/\(function\\|class\\|namespace\)\s<CR>:let @/ = ''\|set hlsearch<CR>
set sts=4 sw=4 ts=4
set suffixesadd+=.fe
set suffixesadd+=.fec
set suffixesadd+=.feh
