"set ts=8 sts=8 sw=8
set noexpandtab

" Prefer foo.go over foo
set suffixes+=,,

"set makeprg=echo\ '=========='\ go\ run\ %\ '==========';go\ run\ %
"nnoremap R :make<cr>
source ~/.vim/pairmap.vim

" go get code.google.com/p/go.tools/cmd/goimports
let g:gofmt_command = 'goimports'

"nmap <buffer> [[ :set nohlsearch<CR>?func <CR>:let @/ = ''\|set hlsearch<CR>
"nmap <buffer> ]] :set nohlsearch<CR>/func <CR>:let @/ = ''\|set hlsearch<CR>
nmap <leader>o :call OpenOtherFile()<cr>
"nmap <leader>i :GoInfo<cr>

" move to after/ftplugin/go.vim
" "nmap <buffer> [[ 0:call search('func \\|= func(', 'bsW')<cr>w
" nmap <buffer> [[ 0:call search('func\( ([^)]\+)\)\= \zs\\|[A-z0-9]* = func(', 'bsW')<cr>
" "nmap <buffer> ]] :call search('func ', 'sW')<cr>w
" nmap <buffer> ]] :call search('func\( ([^)]\+)\)\= \zs\\|[A-z0-9]* = func(', 'sW')<cr>
" "nmap <buffer> <c-]> :GoDef<cr>

"inoremap fpn fmt.Println()<esc>i
"inoremap LPF log.Printf("")<esc>2F"a

"inoremap IFE if err != nil {:call GoInsertLoggerFunction()$a(": %v\n", err)}kf":call InsertCurrentFunctionName()<cr>
inoremap IFE if err != nil {:call GoInsertLoggerFunction()$a("%v", err)}kf"
inoremap TF func TestFoo(t *testing.T) {}kkfFcw

"nnoremap <buffer> <leader>f :call InsertCurrentFunctionName()<cr>
nnoremap <buffer> <leader>F :call ShowFuncName('^\(func \\|var [a-zA-Z0-9_]\+ =\)')<cr>
" nnoremap <buffer> <leader>g :call FindPackageFunction(expand('<cWORD>'))<cr>
nnoremap <buffer> <leader>g :call ShowLocalDef(expand('<cword>'))<cr>
nnoremap <buffer> <leader>g :call ShowOrGotoDef()<cr>
set tags=.tags

"setlocal omnifunc=go#complete#Complete

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
"nnoremap <leader>M ma?^func <cr>yy'apo}<esc>kw

" vim-go
let g:go_textobj_enabled = 0
"let g:go_auto_sameids = 1
nnoremap <leader><space> :GoSameIdsToggle<cr>
hi goSameId ctermbg=41 ctermfg=black

command! -nargs=? Fun :g/^\(func \|var [A-z_0-9]\+ = func\).*<args>/
command! -nargs=? Met :g/^func \(.*<args>/

augroup LspGo
  au!
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'go-lang',
      \ 'cmd': {server_info->['gopls']},
      \ 'whitelist': ['go'],
      \ })
  autocmd FileType go setlocal omnifunc=lsp#complete
  "autocmd FileType go echoe "Go Go"
  autocmd FileType go nmap <buffer> gd <plug>(lsp-definition)
  "autocmd FileType go nmap <buffer> ,n <plug>(lsp-next-error)
  "autocmd FileType go nmap <buffer> ,p <plug>(lsp-previous-error)
augroup END

if exists('g:loaded_lsp_settings') && g:loaded_lsp_settings
	nnoremap K :LspHover<cr>
end
