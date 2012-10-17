let mapleader = ','

cnoremap <c-k> <up>
inoremap <c-d> :w
nnoremap <bs> !!sh<cr>
nnoremap <c-d> :w<cr>
nnoremap <c-]> g<c-]>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-w>] <c-w>g<c-]>
nnoremap <f2> :bprev<cr>
nnoremap <f3> :bnext<cr>
nnoremap <c-i> :call PreviewWord()<cr>
nnoremap  gT
nnoremap <leader>] :<C-U>exec "tab tjump " . expand('<cword>')<cr>
nnoremap <cr> :nohl<cr>
nnoremap Q :q
nnoremap <leader>t :TlistOpen<cr>
nnoremap \\ :set invwrap<cr>

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

