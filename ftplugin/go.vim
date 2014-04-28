set ts=8 sts=8 sw=8 noexpandtab

set makeprg=echo\ '=========='\ go\ run\ %\ '==========';go\ run\ %
nnoremap R :make<cr>
source ~/.vim/pairmap.vim

" go get code.google.com/p/go.tools/cmd/goimports
let g:gofmt_command = 'goimports'

nmap <buffer> [[ :set nohlsearch<CR>?func <CR>:let @/ = ''\|set hlsearch<CR>
nmap <buffer> ]] :set nohlsearch<CR>/func <CR>:let @/ = ''\|set hlsearch<CR>
