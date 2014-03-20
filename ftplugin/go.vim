set ts=8 sts=8 sw=8 noexpandtab

set makeprg=echo\ '=========='\ go\ run\ %\ '==========';go\ run\ %
nnoremap R :make<cr>
source ~/.vim/pairmap.vim

nmap [[ :set nohlsearch<CR>?func <CR>:let @/ = ''\|set hlsearch<CR>
nmap ]] :set nohlsearch<CR>/func <CR>:let @/ = ''\|set hlsearch<CR>
