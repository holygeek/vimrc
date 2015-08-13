set ts=8 sts=8 sw=8 noexpandtab

set makeprg=echo\ '=========='\ go\ run\ %\ '==========';go\ run\ %
nnoremap R :make<cr>
source ~/.vim/pairmap.vim

" go get code.google.com/p/go.tools/cmd/goimports
" let g:gofmt_command = 'goimports'

nmap <buffer> [[ :set nohlsearch<CR>?func <CR>:let @/ = ''\|set hlsearch<CR>
nmap <buffer> ]] :set nohlsearch<CR>/func <CR>:let @/ = ''\|set hlsearch<CR>

inoremap fpn fmt.Println()<esc>i

inoremap IFE if err != nil {fmt.Printf(": %v\n", err)}kf":call InsertCurrentFunctionName()<cr>
inoremap TF func TestFoo(t *testing.T) {}kkfFcw

nnoremap <buffer> <leader>f :call InsertCurrentFunctionName()<cr>

setlocal omnifunc=go#complete#Complete

function! GetGoFuncName(line)
	let l = matchlist(a:line, 'func \(([^)]\+) \)\?\([a-zA-Z_][a-zA-Z0-9_]\+\)')
	return l[2]
endfun

function! InsertCurrentFunctionName()
	let line = getline(search('^func ', 'bn'))
	if len(line) == 0
		return
	endif
	let fname = GetGoFuncName(line)
	exec 'normal a' . fname . '()'
endfun
