" Readability hack
" Test is like this (the file readability.vim has to be in CWD):
" $ cd some/dir; 
" $ vi foo.c bar.c -o \
" -c 'command F exe "normal \<f7>"|redraw!' \
" -c 'command S sleep 300m' \
" -c 'function DO()
"   redraw!
"   S
"   F
"   S
"   F
"   S
"   wincmd j
"   F
"   S
"   F
"   S
"   wincmd k
"   F
"   S
"   wincmd j
"   F
"   S
"   F
"   S
"   wincmd k
"   F
"   S
"   qa
" endfun' -c 'call DO()'
"
au BufReadPost *.c,*.h call s:SetupFriendlySyn()|
  \nnoremap <f7> mf:call MakeReadable()<cr>

function s:SetupFriendlySyn()
  if exists('b:did_setup_friendly')|return|endif
  for fname in keys(s:makeFriendly)
    exe "syn keyword Readable " . fname . '_' . s:makeFriendly[fname]
  endfor

  hi Readable ctermbg=brown ctermfg=white

  let b:did_setup_friendly = 1
endfun

let b:topLine = 0
function MakeReadable()
  let b:topLine = line('w0')
  if ! exists('b:flipUserFriendly')
    let b:flipUserFriendly = 1
  endif

  if b:flipUserFriendly
    for [key, value] in items(s:makeFriendly)
      call s:makeFriend(key, value)
    endfor
  else
    undo
  endif

  exe b:topLine
  normal zt`f

  let b:flipUserFriendly = ! b:flipUserFriendly
endfun

function! s:makeFriend(name, suffix)
  let replacement =  a:name . "_" . a:suffix
  let pattern = a:name

  if ! b:flipUserFriendly
    let pattern = replacement
    let replacement =  a:name
  endif

  exe "%s/\\<" . pattern . "\\>/" . replacement . "/ge"
endfun
if ! exists("s:makeFriendly")
  let s:makeFriendly = {}
  let s:makeFriendly.unfriendly = 'more_friendly'
endif
