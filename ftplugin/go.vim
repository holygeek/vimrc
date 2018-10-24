"set ts=8 sts=8 sw=8
set noexpandtab

" Prefer foo.go over foo
set suffixes+=,,

set makeprg=echo\ '=========='\ go\ run\ %\ '==========';go\ run\ %
nnoremap R :make<cr>
source ~/.vim/pairmap.vim

" go get code.google.com/p/go.tools/cmd/goimports
" let g:gofmt_command = 'goimports'

"nmap <buffer> [[ :set nohlsearch<CR>?func <CR>:let @/ = ''\|set hlsearch<CR>
"nmap <buffer> ]] :set nohlsearch<CR>/func <CR>:let @/ = ''\|set hlsearch<CR>
nmap <buffer> [[ 0:call search('func ', 'bsW')<cr>w
nmap <buffer> ]] :call search('func ', 'sW')<cr>w
"nmap <buffer> <c-]> :GoDef<cr>

"inoremap fpn fmt.Println()<esc>i
"inoremap LPF log.Printf("")<esc>2F"a

"inoremap IFE if err != nil {:call GoInsertLoggerFunction()$a(": %v\n", err)}kf":call InsertCurrentFunctionName()<cr>
inoremap IFE if err != nil {:call GoInsertLoggerFunction()$a("%v", err)}kf"
inoremap TF func TestFoo(t *testing.T) {}kkfFcw

"nnoremap <buffer> <leader>f :call InsertCurrentFunctionName()<cr>

setlocal omnifunc=go#complete#Complete

function! GoInsertLoggerFunction()
	if mine#isGoMainFile()
		let fname = 'log.Fatalf'
	elseif mine#isGoTestFile()
		let fname = 't.Fatalf'
	else
		let fname = 'log.Printf'
	endif
	exe "normal a		" . fname
endfun

function! GetGoFuncName(line)
	let l = matchlist(a:line, 'func \(([^)]\+) \)\?\([a-zA-Z_][a-zA-Z0-9_]\+\)')
	if len(l) < 3
		return ""
	endif
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

" Copy previous function name and args
nnoremap <leader>M ma?^func <cr>yy'apo}<esc>kw

" vim-go
"let g:go_auto_sameids = 1
nnoremap <leader><space> :GoSameIdsToggle<cr>
hi goSameId ctermbg=41 ctermfg=black
