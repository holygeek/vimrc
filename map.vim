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
"nnoremap <leader>c :call ToggleColorColumn()<cr>
nnoremap <leader>C :CommitInfo<cr>
nnoremap <leader>D :windo diffthis<cr>
nnoremap <leader>G :call GithubURL(expand('<cWORD>'))<cr>
nnoremap <leader>i :call PreviewWord()<cr>
nnoremap <leader>l :cnext<cr>
nnoremap <leader>h :cprev<cr>
" replace %xx-encoded characters with their actual character
nnoremap <leader>N :%s/%\([0-9A-F][0-9A-F]\)/\=nr2char(str2nr(submatch(1), 16))/g<cr>
nnoremap <leader>n :call ToggleLineNumberSettings()<cr>
" prettify sql:
vnoremap <Leader>rp :s/\<update\>\\|\<select\>\\|\<from\>\\|\<where\>\\|\<left join\>\\|\<inner join\>\\|\<group by\>\\|\<order by\>\\|\<\(and\\|or\\|case\\|then\\|else\\|end\)\>/\r\U&\r\t/gie<cr><esc>
nnoremap <leader>s :set spell!<cr>
nnoremap <leader>z :set fdm=marker fmr={,}<cr>
nnoremap <leader><leader> zA
"nnoremap <leader>p :set paste! paste?
nnoremap <leader>p :set paste<cr>i<c-o>"+p<esc>:set nopaste<cr>
nnoremap <leader>R :call ViewRace('')<cr>
nnoremap  gT
nnoremap <leader>] :<C-U>exec "tab tjump " . expand('<cword>')<cr>
if has("reltime")
    nnoremap <expr> Q Quit()
else
    nnoremap Q :q<cr>
endif
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
nnoremap <right> :call NextErrorOrBuffer()<CR>
nnoremap <left> :call PrevErrorOrBuffer()<CR>

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
"nmap [1;4C :cnext<CR>
"nmap [1;4D :cprev<CR>

command -nargs=? CommitInfo call CommitInfo(<q-args>)
command -nargs=* Help tabnew +help|only
command -nargs=1 DIFF call Diff(<q-args>)
command Only tab split
command -nargs=? Tab tab new <args>
command Tab1 set ts=1 sts=1 sw=1
command Tab2 set ts=2 sts=2 sw=2
command Tab4 set ts=4 sts=4 sw=4
command Tab8 set ts=8 sts=8 sw=8
command FoldBrace set foldmethod=marker foldmarker={,}
