"nmap <buffer> [[ 0:call search('func \\|= func(', 'bsW')<cr>w
nmap <buffer> [[ 0:call search('func\( ([^)]\+)\)\= \zs\\|[A-z0-9]* = func(', 'bsW')<cr>
"nmap <buffer> ]] :call search('func ', 'sW')<cr>w
nmap <buffer> ]] :call search('func\( ([^)]\+)\)\= \zs\\|[A-z0-9]* = func(', 'sW')<cr>
"nmap <buffer> <c-]> :GoDef<cr>

" Rest of these are govim specific
if !isdirectory(expand('~/.vim/pack/plugins/opt/govim/'))
	finish
endif

" Load govim on demand by doing ":packadd govim"
if !exists("g:govimpluginloaded")
	finish
endif

call govim#config#Set("HighlightDiagnostics", 0)

" https://github.com/govim/govim/wiki/vimrc-tips
nmap <silent> <buffer> <Leader>i : <C-u>call GOVIMHover()<CR>
