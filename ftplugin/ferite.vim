source ~/.vim/pairmap.vim
nmap <buffer> [[ :set nohlsearch<CR>?\(function\\|class\\|namespace\)\s<CR>:let @/ = ''\|set hlsearch<CR>
nmap <buffer> ]] :set nohlsearch<CR>/\(function\\|class\\|namespace\)\s<CR>:let @/ = ''\|set hlsearch<CR>
set sts=2 sw=2 ts=2
set noexpandtab
set suffixesadd+=.fe
set suffixesadd+=.fec
set suffixesadd+=.feh

inoremap cpn Console.println();<esc>F)i
inoremap cpe Console.printlnErr();<esc>F)i
