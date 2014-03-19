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

function! DirName(path)
    return substitute(a:path, '/[^/]\+$', '', '')
endfun

function! TravelUpFindFile(startdir, filename)
  let dir = a:startdir
  let file = dir . '/' . a:filename
  while ! filereadable(file)
    if dir == ''
      let file = ''
      break
    endif
    let dir = DirName(dir)
    let file = dir . '/' . a:filename
  endwhile
  return file
endfun

function! IsManagedByGit(dir)
  let cmd = "git -C " . shellescape(a:dir) . " rev-parse --git-dir"
  let git_dir = system(cmd)
  return strlen(git_dir) > 0
endfun

function! SetPathIfIsGitRepo()
  if filereadable(expand("%"))
    let dir = expand("%:p:h")
  else
    let dir = getcwd()
  endif
  if match(dir, '/\.git') != -1
    return
  endif
  if ! IsManagedByGit(dir)
    return
  endif
  let git_top_level = split(system("git -C '" . dir . "' rev-parse --show-toplevel"))[0]
  exec "set path+=" . git_top_level . "/**"
endfun

" Recursively find tags file starting from the file's directory and going up
function! FindAndSetLocalTags()
  if filereadable(expand("%"))
    let dir = expand("%:p:h")
  else
    let dir = getcwd()
  endif
  if IsManagedByGit(dir)
    " Delegate to fugitive
    return
  endif

  let tagfile = TravelUpFindFile(dir, 'tags')

  if strlen(tagfile) > 0 && filereadable(tagfile)
    exec 'setlocal tags=' . tagfile
  endif
endfun

function! FindAndSetMgitTags()
  if filereadable(expand("%"))
    let dir = expand("%:p:h")
  else
    let dir = getcwd()
  endif
  let cwdlen = strlen(dir)

  let mgitfile = TravelUpFindFile(dir, '.mgit')
  if strlen(mgitfile)==0|return 0|endif
  if !filereadable(mgitfile)|return 0|endif

  let mgitcontent = split(system("cat " . mgitfile), "\n")
  let mgitdir = DirName(mgitfile)
  let tagWasSet = 0
  for d in mgitcontent
    let gitworkdir = mgitdir . '/' . d
    if cwdlen > strlen(gitworkdir) && 0 == match(gitworkdir, "^" . dir)
      continue
    endif
    let tagfile = gitworkdir . '/.git/tags'
    if filereadable(tagfile)
      exec 'set tags+=' . tagfile
      let tagWasSet = 1
  endif
  endfor
  return tagWasSet
endfun

let s:colorcolumn_begin = 121
let s:colorcolumn_end = 300

function! SetColumnBG()
   let &colorcolumn=join(range(s:colorcolumn_begin,s:colorcolumn_end), ',')
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
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
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
  let g:lastQuitAttempt = reltime()
  function! Quit()
    if has("reltime")
      let diff = reltime(g:lastQuitAttempt, reltime())
      let g:lastQuitAttempt = reltime()
      let seconds = diff[0]
      let ms = diff[1]
      " How fast can you hit Q twice?
      if seconds == 0 && ms < 200000
        return ":q!\<cr>"
      endif
    endif

    return ":q\<cr>"
  endfun
endif

nnoremap <expr> Q Quit()

let g:timediffopt = ''
command! TimeDiff :call TimeDiff()
function! TimeDiff()
  vnew
  set nonu nornu
  exec 'r!timediff ' . g:timediffopt . ' ' . bufname(0)
  set buftype=nofile
  "normal gg
  normal ggdd
  wincmd l
  normal magg
  windo setlocal scrollbind cursorbind foldcolumn=0 nowrap nofoldenable
  normal `a
  wincmd h
  999winc <
  7winc >
  wincmd l
endfun

let Closer = { '{' : '}', '[' : ']', '(' : ')', '<' : '>' }
function! InsertClosing()
    "let col = col('.')
    if ! search('[[({]', 'bs')
        return
    endif

    normal "cy `'
    let closer = g:Closer[@c]
    exec 'normal a' . closer
endfun

function! ShiftCursorRight()
  return "l%%a"
endfun

function! ShowFuncName(function_regex)
  set lazyredraw
  let current_column=col('.')
  let current_line=line('.')
  let found_at = search(a:function_regex, 'bW')
  if found_at > 0
    exec line(".") . 'p'
    call cursor(current_line, current_column)
  else
    echo 'Not in any function'
  endif

  set nolazyredraw
endfun

function! FlipFold()
 if !exists("s:FlipFold")
   let s:Zfdm = &fdm
   let s:Zfdl = &fdl
   let s:Zfdc = &fdc
   let s:Zfde = &fde
   let s:FlipFold = 1
   setlocal foldmethod=expr foldlevel=0 foldcolumn=0
     \ foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2
"     \ foldexpr=getline(v:lnum)!~@/
   exec "normal gg``"
 else
   if s:Zfdm == 'manual'
     setl fdm=diff
     redraw
   endif
   let &fdm = s:Zfdm
   let &fdl = s:Zfdl
   let &fdc = s:Zfdc
   let &fde = s:Zfde
   unlet s:FlipFold s:Zfdm s:Zfdl s:Zfdc s:Zfde
 endif
endfunction

function! FindFileType()
	if match(getline(1), 'package .*::.*') != -1
	  set ft=perl
	elseif match(getline(1), '^Index: ') != -1
	  set ft=diff
	endif
endfunction
