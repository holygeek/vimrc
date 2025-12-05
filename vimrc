set nocp
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm

" url decode %s/%\(\x\x\)/\=nr2char('0x' .. submatch(1))/ge

if has('filterpipe')
	set noshelltemp
endif

set viminfo='500,<1000,s100,h

if filereadable(".git/tags")
  " tags set during VimEnter is too late for vim -t tag to see, hence:
  set tags=.git/tags
endif

let g:clang_library_path='/usr/lib'

" Put pathogen-activated stuff into ~/.vim/bundle
if filereadable(expand('~/.vim/autoload/pathogen.vim'))
  call pathogen#infect()
endif
if isdirectory(expand('~/.vim/pack/nice/start/vim-go'))
  let g:go_fmt_command = "goimports"
  let g:go_jump_to_error = 1
elseif isdirectory(expand('~/go/misc/vim'))
  set rtp+=~/go/misc/vim
  autocmd FileType go compiler go
endif

if isdirectory(expand('~/code/fzf'))
	set rtp+=~/code/fzf
endif

"if filereadable(expand('~/gocode/bin/gocode'))
"  set rtp+=~/gocode/src/github.com/nsf/gocode/vim
"endif
set fo+=n
let g:is_posix = 1
let &background="dark"
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
    "colorscheme solarized
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
	
"hi ModifiedFileStatus ctermbg=darkgreen ctermfg=black
"hi RO ctermfg=white ctermbg=red

func FileDir()
	return expand('%:p:~:h')
endfun

func FileDirMaybeWithSlash()
	let d = expand('%:h')
	if len(d) == 0
		return ""
	end
	return d . '/'
endfun

hi User1 ctermbg=black

set statusline=%#Error#%{&paste?'[PASTE]':''}%#ModifiedFileStatus#%m%*%{FileDirMaybeWithSlash()}%1*%t%*\ %y\ %{exists('b:appname')?'('.b:appname.')':''}%#RO#%r%*\ %l:%c%V\ %p%%%L\ %<%{FileDir()}\ %{exists('b:env')&&len(b:env)>0?'('.b:env.')':''}\ %o\ %{exists('b:swapexists')?'\ RO!':''}
" TODO add len(getqflist()) and len(getloclist(0))
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
"set showbreak='♐ '
"let &showbreak = '♫ '
"let &showbreak = '⚑ '

" wide unicode gives error:
"let &showbreak = '♐ '
"let &showbreak = '⚓ '
" Error detected while processing /Users/nazri.ramliy/.vim/vimrc:
" line  131:
" E595: 'showbreak' contains unprintable or wide character

set secure
set autoindent " smartindent
set shiftround
"set wildmode=full:list wildmenu
set wildmode=list:longest,full wildmenu
set wildignore+=*.o,*.lo,*.so,*.gcda,*.gcno,*~
"set wildignore+=config.*
set showcmd

set isfname+=@-@

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
  let scriptnames = [ 'addons', 'plug', 'clang', 'completion', 'local', 'ycm', 'work' ]
  for name in scriptnames
    call LoadIfExists(name)
  endfor
endif

" go guru output
set errorformat+=%f:%l.%c-%[%^:]%#:\ %m,%f:%l:%c:\ %m

if IsInGitRepo()
	set grepprg=git\ grep\ -n\ $*\ 
end

let g:netrw_browse_split = 1

set timeoutlen=350

"source ~/.vim/vimplug.vim

if &diff
	"colorscheme diff
	"highlight! link DiffText guibg=rosybrown guifg=#cccccc
	highlight! DiffText guibg=brown guifg=black
endif
