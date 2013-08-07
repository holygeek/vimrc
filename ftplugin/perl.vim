let b:did_ftplugin = 1
" let perlpath='no thank you'

if exists("b:did_insert_dumper_map")
	finish
endif
let b:did_insert_dumper_map = 1

set commentstring=#%s
set fo+=ro
nnoremap <leader>d :call InsertDumper()<cr>

function! InsertDumper()
	let found = search('use\s*Data::Dumper;', 'nb')

	set lazyredraw
	normal mi
	if ! found
		let where = search('^\s*package', 'nb')
		exec where . "put ='use Data::Dumper;'"
	endif
	normal `ioprint STDERR Dumper $foo;$Bct;
	set nolazyredraw
endfun

source ~/.vim/pairmap.vim
source ~/.vim/nopod.vim
set fdm=expr foldexpr=FoldPod(v:lnum)
