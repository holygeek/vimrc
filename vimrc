set nocp
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm

syn on
filetype on
filetype plugin on
colorscheme desert256

set cinkeys-=0#
set hlsearch
set incsearch
set showfulltag
set smartcase
set notitle
set ruler
set wildmenu
	
function! BufferCount()
        return len(filter(range(1,bufnr('$')),'buflisted(v:val)'))
endfun
set statusline=%m%f%m\ %y\ %r\ %=%n/%{BufferCount()}\ %o\ \ %l/%Lc%c%V\ %P
set laststatus=2

set backspace=indent,eol,start
set exrc
set guifont=DejaVu\ Sans\ Mono\ 11
set guioptions=
set linebreak
set listchars=tab:\|-,trail:@
set mousefocus " GUI only:cursor focus follows mouse
set pt=<f12>
set rnu
set secure
set autoindent smartindent
set shiftround
set wildmode=full:list wildmenu

source ~/.vim/autocommands.vim
source ~/.vim/customcolors.vim
source ~/.vim/functions.vim
source ~/.vim/map.vim

for i in [ 'work', 'home', 'addons', 'clang' ]
	let fullpath = expand('~/.vim/' . i . '.vim')
	if filereadable(fullpath)
		exec 'source ' . fullpath
	endif
endfor
