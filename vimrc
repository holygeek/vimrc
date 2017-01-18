set nocp
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm

if filereadable(".git/tags")
  " tags set during VimEnter is too late for vim -t tag to see, hence:
  set tags=.git/tags
endif

let g:clang_library_path='/usr/lib'

" Put pathogen-activated stuff into ~/.vim/bundle
if filereadable(expand('~/.vim/autoload/pathogen.vim'))
  call pathogen#infect()
endif
if isdirectory(expand('~/.vim/vim-go'))
  let g:go_fmt_command = "goimports"
  set rtp+=~/.vim/vim-go
elseif isdirectory(expand('~/go/misc/vim'))
  set rtp+=~/go/misc/vim
  autocmd FileType go autocmd BufWritePre <buffer> Fmt
  autocmd FileType go compiler go
endif
"if filereadable(expand('~/gocode/bin/gocode'))
"  set rtp+=~/gocode/src/github.com/nsf/gocode/vim
"endif
set fo+=n
let g:is_posix = 1
syn on
filetype on
filetype plugin indent on
let g:bgfile = "/dev/shm/term/" . $SHORT_TERM_NAME . "/bg"
if filereadable(g:bgfile)
  let g:BG=system("cat " . g:bgfile)
else
  let g:BG="black"
endif
if $TERM_NAME != 'bigterm'
  if g:BG == 'black'
    colorscheme desert256
  endif
else
  let g:BG = 'white'
endif

set breakindent
set cinkeys-=0#
set hlsearch
set incsearch
set nostartofline
set sessionoptions-=options
set showfulltag
set smartcase
set notitle
set ruler
	
hi ModifiedFileStatus ctermbg=darkgreen ctermfg=black
hi RO ctermfg=white ctermbg=red

set statusline=%#Error#%{&paste?'[PASTE]':''}%#ModifiedFileStatus#%m%*%f\ %y\ %#RO#%r%*\ %l:%c%V\ %p%%%L\ %<%{expand('%:p:~:h')}\ %o
"%=+%-{@+[0:10]}\ *%-{@*[0:10]}

set laststatus=2

set backspace=indent,eol,start
if getcwd() =~ '^' . resolve($HOME)
  set exrc
endif
set guifont=DejaVu\ Sans\ Mono\ 10
set guicursor=a:block-blinkon0
set guioptions=
set linebreak
set listchars=tab:>-,trail:@
set mousefocus " GUI only:cursor focus follows mouse
set pt=<f12>
if exists('+rnu')
  set nu rnu
endif
"let &showbreak = '» '
"let &showbreak = '♫ '
"let &showbreak = '⚑ '
let &showbreak = '♐ '
"let &showbreak = '⚓ '
set secure
set autoindent smartindent
set shiftround
"set wildmode=full:list wildmenu
set wildmode=list:longest,full wildmenu
set wildignore+=*.o,*.lo,*.so,*.gcda,*.gcno,*~
"set wildignore+=config.*

source ~/.vim/functions.vim
source ~/.vim/autocommands.vim
source ~/.vim/customcolors.vim

source ~/.vim/map.vim

function! LoadIfExists(name)
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
  call LoadIfExists('ycm')
  call LoadIfExists('work')
else
  let scriptnames = [ 'addons', 'clang', 'completion', 'local', 'ycm', 'work' ]
  for name in scriptnames
    call LoadIfExists(name)
  endfor
endif
