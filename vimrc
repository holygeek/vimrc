set nocp
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm

let g:clang_library_path='/usr/lib'

" Put pathogen-activated stuff into ~/.vim/bundle
if filereadable(expand('~/.vim/autoload/pathogen.vim'))
  call pathogen#infect()
endif
if isdirectory(expand('~/go/misc/vim'))
  set rtp+=~/go/misc/vim
endif
syn on
filetype on
filetype plugin indent on
if $TERM_NAME != 'bigterm'
  colorscheme desert256
endif

set cinkeys-=0#
set hlsearch
set incsearch
set nostartofline
set sessionoptions-=options
set showfulltag
set smartcase
set notitle
set ruler
	
set statusline=%#Error#%{&paste?'[PASTE]':''}%*%m%f%m\ %y\ %r\ %o\ \ %l:%c%V\ %p%%%L
set laststatus=2

set backspace=indent,eol,start
if getcwd() =~ '^' . resolve($HOME)
  set exrc
endif
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
  call LoadIfExists('local')
  call LoadIfExists('work')
else
  let scriptnames = [ 'addons', 'clang', 'completion', 'local', 'work' ]
  for name in scriptnames
    call LoadIfExists(name)
  endfor
endif
