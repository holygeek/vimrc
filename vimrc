set nocp
set t_Co=16
" set t_Co=256
" set t_AB=[48;5;%dm
" set t_AF=[38;5;%dm

let g:clang_library_path='/usr/lib'

syntax enable
" if $TERM_NAME != 'bigterm'
"   if $XTERMS_BG == 'black'
"     colorscheme desert256
"   endif
" endif

let solarized_dark = 'dark'
let solarized_light = 'light'
if len($STY)
  " Bug with solarized?
  let solarized_dark = 'light'
  let solarized_light = 'dark'
endif

let background="light"
if $XTERMS_BG == '#fdf6e3'       " Light
  let background = solarized_light
elseif $XTERMS_BG == '#002b36'   " Dark
  let background = solarized_dark
endif
exe "set background=" . background
" let g:solarized_termcolors=256
colorscheme solarized

filetype on
filetype plugin indent on

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
  call LoadIfExists('local')
  call LoadIfExists('work')
else
  let scriptnames = [ 'addons', 'clang', 'completion', 'local', 'work' ]
  for name in scriptnames
    call LoadIfExists(name)
  endfor
endif
