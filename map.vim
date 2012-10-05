inoremap <c-d> :w
nnoremap <c-d> :w<cr>
nnoremap Q :q
nnoremap <c-k> <c-w>k
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
cnoremap <c-k> <up>
nnoremap <tab> gt
nnoremap  gT
nnoremap <c-]> g<c-]>
nnoremap <c-w>] <c-w>g]
nnoremap <f2> :bprev<cr>
nnoremap <f3> :bnext<cr>
nnoremap <c-i> :call PreviewWord()<cr>

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

