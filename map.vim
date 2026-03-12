command! QQ qa!

" add fourth column, convert timetstamp in 3rd into YYYY-MM-DDTHH.MM.SS
" %s/^\([^,]*,[^,]*,\)\([0-9]\+\)\(,.*\)/\=submatch(1).submatch(2).','.strftime('%Y-%m-%dT%H.%M.%S', submatch(2)).submatch(3)/

let mapleader = ' '

nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap [q :<c-U>exe "cprevious " . v:count1<cr>
nnoremap ]q :<c-U>exe "cnext "     . v:count1<cr>
inoremap jk <esc>
" " Need ale, clone it into ~/.vim/pack/nice/start/ale
" nmap <silent> <C-up> <Plug>(ale_previous)
" nmap <silent> <C-down> <Plug>(ale_next)

inoremap <c-@> <esc>:call InsertClosing()<cr>a
cmap %/ %:p:h/
cnoremap <c-k> <up>
cnoremap <c-j> <down>
inoremap <c-d> :w
nnoremap <c-d> :w<cr>
"nnoremap <c-]> g<c-]>
nnoremap <c-h> :wincmd h<cr>
nnoremap <c-j> :wincmd j<cr>
nnoremap <c-k> :wincmd k<cr>
nnoremap <c-l> :wincmd l<cr>
inoremap <expr> <c-l> InsertNextNumber()
nnoremap <c-w>] <c-w>g<c-]>
nnoremap <f2> :bprev<cr>
nnoremap <f3> :bnext<cr>
nnoremap _ <c-w>-
nnoremap + <c-w>+
nnoremap <leader>- :call ShrinkWindowToFile()<cr>
"nnoremap <leader>c :call ToggleColorColumn()<cr>
nnoremap <leader>C :CommitInfo<cr>
"nnoremap <leader>D :windo diffthis<cr>
nnoremap <leader>D a<esc>:r!date<cr>kgJA
nnoremap <leader>G :call GithubURL(expand('<cWORD>'))<cr>
"nnoremap <leader>i :call PreviewWord()<cr>
"nnoremap <leader>l :cnext<cr>
"nnoremap <leader>h :cprev<cr>
" replace %xx-encoded characters with their actual character

nnoremap <leader>N :%s/%\([0-9A-F][0-9A-F]\)/\=nr2char(str2nr(submatch(1), 16))/g<cr>
nnoremap <leader>n :call ToggleLineNumberSettings()<cr>
" prettify sql:
"vnoremap <Leader>rp :s/\<update\>\\|\<select\>\\|\<from\>\\|\<where\>\\|\<left join\>\\|\<inner join\>\\|\<group by\>\\|\<order by\>\\|\<\(and\\|or\\|case\\|then\\|else\\|end\)\>/\r\U&\r\t/gie<cr><esc>
vnoremap <Leader>rp :!sqlformat --reindent --keywords upper --identifiers lower -<cr>
"nnoremap <leader>s :set spell!<cr>
" \z mapping (vim list starred) - create / delete fold on search
" pattern (diomidis' telescope):
" nnoremap \z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=0<CR>
nnoremap <silent> <leader>z :call FlipFold()<CR>
nnoremap <leader>Z :set fdm=marker fmr={,}<cr>
nnoremap <leader><leader> zA
"nnoremap <leader>p :set paste! paste?
"nnoremap <leader>p :set paste<cr>i<c-o>"+p<esc>:set nopaste<cr>
nnoremap <leader>R :call ViewRace('')<cr>
nnoremap <leader>O :!open "<cWORD>"<cr><cr>
nnoremap <leader>y <cmd>let @* = StripWordBoundaryRegex(@/)<cr><cmd>echo @*<cr>
nnoremap  gT
nnoremap <leader>] :<C-U>exec "tab tjump " . expand('<cword>')<cr>
if has("reltime")
    nnoremap <expr> Q Quit()
else
    nnoremap Q :q<cr>
endif
nnoremap <leader>t :TlistOpen<cr>
nnoremap \\ :set invwrap<cr>

"Thu Jul  3 10:32:06 +08 2025
"this makes fdo-=search doesn't work. probably not worth having this mapping?
noremap <expr> n 'Nn'[v:searchforward] . 'zv'
noremap <expr> N 'nN'[v:searchforward] . 'zv'

" func definition (gf)
"au BufRead *.go nmap <leader>f :new +lexpr\ system('gf\ -l\ <c-r>=expand('<cword>')<cr>')<cr>
au BufRead *.go,*.proto,*.kt nmap <leader>f  :call CodeSearch('gf -l', expand('<cword>'))<cr>
au BufRead *.go,*.proto,*.kt nmap <leader>df :call CodeSearch('gf -l', expand('<cword>'), v:true)<cr>
au BufRead *.go nmap <leader>dm :exec "!datadog.metric.summary " . expand('<cWORD>')<cr>
au FileType diff nmap <leader>f  :call CodeSearch('gf -l', expand('<cword>'))<cr>
au FileType diff nmap <leader>df :call CodeSearch('gf -l', expand('<cword>'), v:true)<cr>
command -nargs=1 Gf call CodeSearch('gf -l', <q-args>)
command -nargs=1 Gdf call CodeSearch('gf -l', <q-args>, v:true)
" search caller (caller)
"au BufRead *.go nmap <leader>l :new +lexpr\ system('caller\ -l\ <c-r>=expand('<cword>')<cr>')<cr>
au BufRead *.go,*.proto,*.kt nmap <leader>l  :call CodeSearch('caller -l', expand('<cword>'))<cr>
au BufRead *.go,*.proto,*.kt nmap <leader>dl :call CodeSearch('caller -l', expand('<cword>'), v:true)<cr>
" Find caller of identifier under cursor, with package qualifier
au BufRead *.go              nmap <leader>L :call  CodeSearch('cs', split(getline(search('^package ', 'cwn')), ' ')[1] . '.' . expand('<cword>'))<cr>
" search occurrences (cs), <cword>
"au BufRead *.go nmap <leader>s :new +lexpr\ system('cs\ <c-r>=expand('<cword>')<cr>')<cr>
au BufRead *.go nmap <leader>s  :let CSWORD=expand('<cword>')\|:call CodeSearch('cs', CSWORD, CSWORD[0] =~# '[[:lower:]]')<cr>
au BufRead *.go,*.proto,*.kt,*.jsx,*.swift,*java nmap <leader>ds :call CodeSearch('cs', expand('<cword>'), v:true)<cr>
command -nargs=1 Count echo <q-args> . ' ' .  count(getline('.'), <q-args>)
command -nargs=0 Column %!column -t
command -nargs=1 Cs  call CodeSearch('cs', <q-args>)
command -nargs=? Csd call CodeSearch('cs', <q-args>, v:true)
" search occurrences (cs), <cWORD>
au BufRead *.go,*.proto,*.kt nmap <leader>S  :call CodeSearch('cs', expand('<cWORD>'))<cr>
au BufRead *.go,*.proto,*.kt nmap <leader>dS :call CodeSearch('cs', expand('<cWORD>'), v:true)<cr>
"au BufRead *.go nmap <leader>S :new +lexpr\ system('cs\ <c-r>=expand('<cWORD>')<cr>')<cr>
"
"https://vi.stackexchange.com/questions/24547/decode-url-percent-decoding
"command UrlDecode %s/%\(\x\x\)/\=nr2char('0x' .. submatch(1))/ge
command! -range=% UrlDecode s/%\(\x\x\)/\=iconv(nr2char('0x' .. submatch(1)), 'utf-8', 'latin1')/ge
" url decode %s/%\(\x\x\)/\=nr2char('0x' .. submatch(1))/ge

command -nargs=1 New call New(<q-args>)

"cabbrev Gbro Git browse
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
command          Only tab split
command -nargs=? Tab tab new <args>
command -nargs=* T term <args>
command          Tab1 set ts=1 sts=1 sw=1
command          Tab2 set ts=2 sts=2 sw=2
command          Tab4 set ts=4 sts=4 sw=4
command          Tab8 set ts=8 sts=8 sw=8
command          FoldBrace set foldmethod=marker foldmarker={,}
command -nargs=1 GE call GitNumberEdit(<args>)
command!         Gblame Git blame

au FileType man nmap <C-Up> <PageUp>
au FileType man nmap <C-Down> <PageDown>

"command PanicPath ma|%s,go/pkg/mod/,$HOME/gopath/pkg/mod,|'a
command PanicPath %s,/go/pkg/mod/,$HOME/gopath/pkg/mod/,
