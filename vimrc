set nocp
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm

let g:clang_library_path='/usr/lib'

syn on
filetype on
filetype plugin on
if $TERM_NAME != 'bigterm'
  colorscheme desert256
endif

set cinkeys-=0#
set hlsearch
set incsearch
set showfulltag
set smartcase
set notitle
set ruler
set wildmenu
	
set statusline=%m%f%m\ %y\ %r\ %o\ \ %l:%c%V\ %p%%%L
set laststatus=2

set backspace=indent,eol,start
set exrc
set guifont=DejaVu\ Sans\ Mono\ 10
set guicursor=a:block-blinkon0
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

source ~/.vim/functions.vim
source ~/.vim/autocommands.vim
source ~/.vim/customcolors.vim

source ~/.vim/map.vim

function LoadIfExists(name)
  let fullpath = expand('~/.vim/' . a:name . '.vim')
  if filereadable(fullpath)
    exec 'source ' . fullpath
  endif
endfun

if v:version <= 604
  call LoadIfExists('addons')
  call LoadIfExists('clang')
  call LoadIfExists('completion')
  call LoadIfExists('home')
  call LoadIfExists('work')
  call LoadIfExists('cscope')
else
  let scriptnames = [ 'addons', 'clang', 'completion', 'home', 'work', 'cscope' ]
  for name in scriptnames
    call LoadIfExists(name)
  endfor
endif
