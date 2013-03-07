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

function! FindAndSetLocalTags()
  let dir = expand("%:p:h")
  let tagfile = dir . '/tags'
  while ! filereadable(tagfile)
    if dir == ''
      let tagfile = ''
      break
    endif
    let dir = substitute(dir, '[^/]\+$', '', '')
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
command Version call Version()

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
command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
  \ | diffthis | wincmd p | diffthis
