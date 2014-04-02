command! QQ qa!

let mapleader = ' '

nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap [q :<c-U>exe "cprevious " . v:count1<cr>
nnoremap ]q :<c-U>exe "cnext "     . v:count1<cr>
inoremap <c-@> <esc>:call InsertClosing()<cr>a
cmap %/ %:p:h/
cnoremap <c-k> <up>
cnoremap <c-j> <down>
inoremap <c-d> :w
nnoremap <c-d> :w<cr>
nnoremap <c-]> g<c-]>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
inoremap <expr> <c-l> InsertNextNumber()
nnoremap <c-w>] <c-w>g<c-]>
nnoremap <f2> :bprev<cr>
nnoremap <f3> :bnext<cr>
nnoremap _ <c-w>-
nnoremap + <c-w>+
nnoremap <leader>- :call ShrinkWindowToFile()<cr>
nnoremap <leader>c :call ToggleColorColumn()<cr>
nnoremap <leader>i :call PreviewWord()<cr>
nnoremap <leader>n :call ToggleLineNumberSettings()<cr>
nnoremap <leader>s :set spell!<cr>
nnoremap <leader>z :set fdm=marker fmr={,}<cr>
nnoremap <leader><leader> zA
"nnoremap <leader>p :set paste! paste?
nnoremap <leader>p :set paste<cr>i<c-o>"+p<esc>:set nopaste<cr>
nnoremap  gT
nnoremap <leader>] :<C-U>exec "tab tjump " . expand('<cword>')<cr>
nnoremap <cr> :nohl<cr>:set list&<cr>
nnoremap <expr> Q Quit()
nnoremap <leader>t :TlistOpen<cr>
nnoremap \\ :set invwrap<cr>
noremap <expr> n 'Nn'[v:searchforward] . 'zv'
noremap <expr> N 'nN'[v:searchforward] . 'zv'

cnoremap <c-y> <c-r>*
vnoremap <leader>f :fold<cr>

" Copy/paste stuff to desktop clipboard <-> window's clipboard (vmware
" clipboard sharing)
nnoremap <c-a-p> "+p
vnoremap <c-a-y> "+y

" cnoremap <c-l> <down>  Default behavior <c-l> in '/' mode is desirable - it
" completes text that is being incrementally searched

map <F8> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
nnoremap <c-]> g<c-]>
" Heaven for jumping through tags:
" Alt-right
nmap [1;3C g<C-]>
" Alt-left
nmap [1;3D <C-T>

" Super+right/left traverse quickfix list
nmap OC :cne<CR>
nmap OD :cprev<CR>

" \z mapping (vim list starred) - create / delete fold on search
" pattern (diomidis' telescope):
" nnoremap \z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=0<CR>
map <silent> <leader>Z :call FlipFold()<CR>

" In gnome terminal these don't work:
" nmap <M-Left> <C-T>
" nmap <M-Right> g<C-]>

" Heaven for jumping through errors:
" <Shift+Alt+left>    next error
" <Shift+Alt+right>   previous error
nmap [1;4C :cnext<CR>
nmap [1;4D :cprev<CR>
