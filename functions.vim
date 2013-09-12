" vim: ts=2 sts=2 sw=2 expandtab
function! OpenOtherFile()
  let file = expand('%')
  let other = ''

  if match(file, '\.c$') >= 0
    let other = substitute(file, '\.c$', '.h', '')
  elseif match(file, '\.h$') >= 0
    let other = substitute(file, '\.h$', '.c', '')
  else
    return
  endif

  if ! filereadable(other)
    echo "File " . other . " not readable"
    return
  endif

  exec ':split ' . other
endfun

" Adapted from :help CursorHold-example
function! PreviewWord()
  let w = expand("<cword>")	" get the word under cursor
  if w !~ '\a'			" if the word contains a letter
    return
  endif

  let startedInPreview = 0
  " Delete any existing highlight before showing another tag
  "silent! wincmd P		" jump to preview window
  if &previewwindow		" if we really get there...
    match none			" delete existing highlight
    "wincmd p			" back to old window
    let startedInPreview = 1
  endif

  " Try displaying a matching tag for the word under the cursor
  try
     exe "ptag " . w
  catch
    return
  endtry

  silent! wincmd P			" jump to preview window
  if &previewwindow			" if we really get there...
       if has("folding")
         silent! .foldopen		" don't want a closed fold
       endif
       call search("$", "b")		" to end of previous line
       let w = substitute(w, '\\', '\\\\', "")
       call search('\<\V' . w . '\>')	" position cursor on match
       " Add a match highlight to the word at this position
      hi previewWord term=bold ctermbg=magenta ctermfg=black
       exe 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
    if ! startedInPreview
	wincmd p			" back to old window
    endif
  endif
endfun

" Recursively find tags file starting from the file's directory and going up
function! FindAndSetLocalTags()
  if filereadable(expand("%"))
    let dir = expand("%:p:h")
  else
    let dir = getcwd()
  endif

  let tagfile = dir . '/tags'
  while ! filereadable(tagfile)
    if dir == ''
      let tagfile = ''
      break
    endif
    let dir = substitute(dir, '/[^/]\+$', '', '')
    let tagfile = dir . '/tags'
  endwhile

  if strlen(tagfile) > 0 && filereadable(tagfile)
    exec 'setlocal tags=' . tagfile
  endif
endfun

function! SetColumnBG()
   let &colorcolumn=join(range(81,300), ',')
   hi ColorColumn guibg=darkgray ctermbg=234
   " When this is on we want to disable linebreak as it will give false
   " positive as 'colorcolumn' counts the virtual column added after 'breakat'
   " chars
   set nolinebreak
   "hi NonText ctermbg=234
endfun

" Pretty print version
function! Version()
    new
    let l:more = &more|
    redir => l:a|silent ver|redir END
    silent 1put = l:a
    /Features included/+1mark a|/system vimrc/-1mark b
    g/^$/d
    normal 'aO
    normal 'bo
    1
    normal }j

    " Make it behave like vim help so that the +feature tags works
    set iskeyword=!-~,^*,^\|,^" buftype=nofile
    syn match missingfeature "-[^ ]\+" contained
    syn region feature start="Features included" end="system vimrc"
          \ contains=missingfeature
    syn match feature "^ [-+].*" contains=missingfeature
    hi missingfeature ctermfg=217
    hi Search ctermfg=217 ctermbg=none
    nnoremap <buffer> Q :q!<cr>
    nnoremap <buffer> <c-]> :exec "help " . substitute(expand('<cWORD>'), '.', '+', '')<CR>
    nmap <buffer> i <c-]>
    let @/ = '-[^ ]\+'
endfunction
command! Version call Version()

" Get the highlight attribute {attr} for {name}
"
" Example:
"
"   :hi LineNr
"   LineNr         xxx term=underline ctermfg=242 guifg=darkgray
"   :echo GetHighlightAttr('LineNr', 'guifg')
"   darkgray
function! GetHighlightAttr(name, attr)
  redir => hl_attrs|exe "silent hi " . a:name|redir END
  let pattern = '.*' . a:attr . '=\([^ ]\+\).*'

  if hl_attrs !~? pattern
    return 'none'
  endif

  return substitute(hl_attrs, pattern, '\1', '')
endfun

" :echo AttributesToDict("one=foo two=bar")
" {'one': 'foo', 'two': 'bar'}
function! AttributesToDict(attributes)
  let ret = {}
  for attr in split(a:attributes)
    let pair = split(attr, '=')
    if len(pair) >= 2
      let ret[pair[0]] = join(pair[1:], ' ')
    endif
  endfor
  return ret
endfun

" Return a Dictionary containing the attributes of the the syntax item {name}
" Example:
"   :hi LineNr
"   LineNr         xxx term=underline ctermfg=242 guifg=darkgray
"   :echo GetHighlightAttrs('LineNr')
"   {'ctermfg': '242', 'term': 'underline', 'guifg': 'darkgray'}
function! GetHighlightAttrs(name)
  redir => hl_attrs|exe "silent hi " . a:name|redir END
  return AttributesToDict(substitute(hl_attrs, '.\{-}xxx ', '', ''))
endfun

" From :help DiffOrig
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
  \ | diffthis | wincmd p | diffthis

function! ToggleLineNumberSettings()
  if &relativenumber && &number
    " Show number only
    set norelativenumber number
  elseif ! &relativenumber && &number
    " No numbers at all
    set norelativenumber nonumber
  else
    set number relativenumber
  endif
endfun

function! ToggleColorColumn()
  if &cc == 0
    let &cc = g:oldcc
  else
    let g:oldcc = &cc
    let &cc = 0
  endif
endfun

function! ShrinkWindowToFile()
  let nLines = line('$')
  let winHeight = winheight(0)
  if winHeight <= nLines
    return
  endif

  let extra = winHeight - nLines
  exec 'resize -' . extra
endfun

function! FoldPod(lnum)
  let synname = synIDattr(synID(a:lnum, 1, 1), 'name')
  if len(synname) == 0
    return '='
  endif
  if synname == 'podCommand' ||
        \ synname == 'podFormat' ||
        \ synname == 'podVerbatimLine' ||
        \ synname == 'podSpecial' ||
        \ synname == 'perlPOD'
    return 1
  endif
  return 0
endfun

function! InsertNextNumber()
  let lnum = search('^\s*[0-9][^ ]\+', 'bnW')
  if lnum == 0
    return "\<c-l>"
  endif

  let number = substitute(getline(lnum), '^ *', '', '')
  let number = substitute(number, ' .*', '', '')
  return number . "\<esc>b\<c-a>A "
endfun

if has("reltime")
  let g:lastQuit = reltime()
endif
function! Quit()
  if has("reltime")
    let diff = reltime(g:lastQuit, reltime())
    let g:lastQuit = reltime()
    let seconds = diff[0]
    let ms = diff[1]
    " How fast can you hit Q twice?
    if seconds == 0 && ms < 200000
      return ":q!\<cr>"
    endif
  endif

  return ":q\<cr>"
endfun

command! TimeDiff :call TimeDiff()
function! TimeDiff()
  vnew
  set nonu nornu
  exec 'r!timediff ' . bufname(0)
  set buftype=nofile
  normal gg
  "normal ggdd
  wincmd l
  normal magg
  windo setlocal scrollbind cursorbind foldcolumn=0 nowrap nofoldenable
  normal `a
  wincmd h
  999winc <
  7winc >
  wincmd l
endfun
