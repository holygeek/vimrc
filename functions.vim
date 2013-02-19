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
      " echoerr "work.vim: Could not find tags file"
      let tagfile = ''
      break
    endif
    let dir = substitute(dir, '/[^/]\+$', '', '')
    let tagfile = dir . '/tags'
  endwhile

  if strlen(tagfile) > 0
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
    'a,'bjoin|normal dd
    let l:ver = split(@", '  *')
    let l:ncols = 4
    let l:txt = []
    let l:group = []
    for i in range(1, len(l:ver))
        call add(l:group, l:ver[i - 1])
        if i % l:ncols == 0
            call add(l:txt, join(l:group, " "))
            let l:group = []
        endif
    endfor
    normal O
    put = join(l:txt, \"\n\")
    " We're at the last line in the newly inserted text
    mark b
    normal {dd
    mark a
    silent 'a,'b!column -t
    g/^$/d
    normal 'aO
    normal 'bo
    1
    normal }j

    " Make it behave like vim help so that the +feature tags works
    set iskeyword=!-~,^*,^\|,^"
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
