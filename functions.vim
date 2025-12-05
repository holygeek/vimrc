" vim: ts=2 sts=2 sw=2 expandtab

function! GetStdout(cmd)
  let stdout = system(a:cmd)
  let lines = split(stdout)
  return lines
endfun

function! RunGitIn(dir, args)
  let cmd = "git -C " . shellescape(a:dir) . " " . a:args
  return GetStdout(cmd)
endfun

function! GitRevParseIn(dir, args)
  return RunGitIn(a:dir, "rev-parse " . a:args)
endfun

function! OpenOtherFile()
  let file = expand('%')
  let other = ''

  if match(file, '\.c$') >= 0
    let other = substitute(file, '\.c$', '.h', '')
  elseif match(file, '\.h$') >= 0
    let other = substitute(file, '\.h$', '.c', '')
  elseif match(file, '_test\.go$') >= 0
    let other = substitute(file, '_test\.go$', '.go', '')
  elseif match(file, '\.go$') >= 0
    let other = substitute(file, '\.go$', '_test.go', '')
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

function! CleanPath(path)
  let cleaned = substitute(a:path, '//*', '/', 'g')
  return substitute(cleaned, '/$', '', '')
endfun

function! DirName(path)
  let cleaned = CleanPath(a:path)
  let cleaned = substitute(cleaned, '[^/]\+$', '', '')
  if len(cleaned) == 0
    return "."
  endif
  if cleaned[-1:-1] == "/"
    return cleaned[0:-2]
  endif
  return cleaned
endfun

function! TravelUpFindFile(startdir, filename)
  let dir = a:startdir
  let file = dir . '/' . a:filename
  while ! filereadable(file)
    if dir == '.' || dir == '/'
      let file = ''
      break
    endif
    let dir = DirName(dir)
    let file = dir . '/' . a:filename
  endwhile
  return file
endfun

function! IsInGitRepo()
  let dir = GetCurrentFileDirOrCurrentDir()
  return IsManagedByGit(dir)
endfun

function! GetGitDir(dir)
  let lines = GitRevParseIn(a:dir, '--git-dir')
  return lines[0]
endfun

function! IsManagedByGit(dir)
  call GitRevParseIn(a:dir, '--is-in-work-tree')
  return v:shell_error == 0
endfun

function! SetPathIfIsGitRepo()
  let dir = GetCurrentFileDirOrCurrentDir()
  if match(dir, '/\.git') != -1
    return
  endif
  if ! IsManagedByGit(dir)
    return
  endif
  "echo "dir " . dir
  let l:git_top_level = split(system("git -C '" . dir . "' rev-parse --show-toplevel"))[0]
  "echo "git_top_level = " . l:git_top_level
  exec "set path=" . l:git_top_level . "/**"
endfun

function! GetCurrentFileDirOrCurrentDir()
  if filereadable(expand("%"))
    let dir = expand("%:p:h")
  else
    let dir = getcwd()
  endif
  return dir
endfun

" Recursively find tags file starting from the file's directory and going up
function! FindAndSetLocalTags()
  let dir = GetCurrentFileDirOrCurrentDir()
  "if IsManagedByGit(dir)
  "  " Delegate to fugitive
  "  return
  "endif

  let tagfile = TravelUpFindFile(dir, 'tags')

  if strlen(tagfile) > 0 && filereadable(tagfile)
    exec 'setlocal tags=' . tagfile
  endif
endfun

function! FindAndAddCscope()
  let dir = GetCurrentFileDirOrCurrentDir()
  let cscopefile = TravelUpFindFile(dir, 'cscope.out')
  if strlen(cscopefile) > 0 && filereadable(cscopefile)
    exec 'cscope add ' . cscopefile
  endif
endfu

function! FindAndSetMgitTagsFromDir(dir)
  let dir = a:dir
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
    let diff = reltime(g:lastQuitAttempt, reltime())
    let g:lastQuitAttempt = reltime()
    let seconds = diff[0]
    let ms = diff[1]
    " How fast can you hit Q twice?
    echom seconds .. "seconds " .. ms .. "ms"
    let maxDelay = 200000
    if has("prof_nsec")
      let maxDelay = 200000000
    endif
    if seconds == 0 && ms < maxDelay
      return ":q!\<cr>"
    endif

    return ":q\<cr>"
  endfun
  nnoremap <expr> Q Quit()
else
  nnoremap <expr> Q :q<cr>
endif

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

function! CurrentChar()
  return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfun

" ShiftCursorRight: Move cursor after " or after )
function! ShiftCursorRight()
  if CurrentChar() == '"'
    " Move cursor after "
    return "la"
  endif
  " Assume that we're inside parenthesis, move cursor to after the closing
  " parenthesis
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

def! FindPackageFunction(cWORD: string, verbose: bool = false)
  var debug = 0
  if verbose || exists('b:debugFindPackageFunction') && b:debugFindPackageFunction
    debug = 1
  endif
  def Debug(text: string)
    if !debug
      return
    endif
    echom 'DEBUG: ' .. text
  enddef

  var fullname = cWORD
  if count(cWORD, '.') >= 3 && cWORD =~ '\.String$'
    fullname = substitute(fullname, '\.String', '', '')
  endif
  fullname = substitute(fullname, '^[(*&]\+\|(.*', '', '')
  fullname = substitute(fullname, '^!', '', '')
  if fullname !~ '\.'
    echoerr fullname .. ' is not package scoped'
    return
  endif
  Debug('fullname ' .. fullname)
  var c = split(fullname, '\.')
  var pkg = c[0]
  var name = c[1]
  name = substitute(name, '[^0-9A-z_].*', '', '')
  var regex = '^\(\t\|import \)\(' .. pkg .. ' "\|".*/' .. pkg .. '"\)'
  Debug('regex ' .. regex)
  var pkgline = getline(search(regex, 'n'))
  Debug('pkgline1 ' .. pkgline)
  if pkgline == ""
    echoerr "could not find import line for package " .. pkg
    return
  endif

  pkgline = substitute(pkgline, 'import ', '', '')
  Debug('pkgline2 ' .. pkgline)
  var pkgpath = pkgline
  Debug('pkgpath1 ' .. pkgpath)
  if stridx(pkgline, ' ') > -1
    pkgpath = split(pkgline, ' ')[1]
    Debug('pkgpath2 ' .. pkgpath)
  endif

  var parentDir = expand('%:h')
  new

  pkgpath = substitute(pkgpath, '[\t"]', '', 'g')
  var isgitrepo: bool = 1
  var pkgdir: string
  var dirs = split(pkgpath, '/')
  var vendored = ""
  if vendored != ''
    if isdirectory(vendored)
      pkgdir = vendor_dir .. pkgpath
    else
      # go.mod
      pkgdir = trim(system("cd " .. parentDir .. ";" .. "go list -json " .. pkgpath .. "|jq -r '.Dir'"))
      Debug("PKGDIR"  .. pkgdir)
      isgitrepo = false
    endif
  else
    pkgdir = trim(system("cd '" .. parentDir .. "'; go list -json " .. pkgpath .. "|jq -r '.Dir'"))
    isgitrepo = 0
    Debug('PKGPATH ' .. pkgpath)
    Debug('PKGDIR  ' .. pkgdir)

    if !isdirectory(expand(pkgdir))
      # maybe go stdlib
      if stridx(dirs[0], '.') == -1
        pkgdir = '/usr/local/go/src/' .. pkgpath
        isgitrepo = 0
      endif
    endif
  endif
  Debug('pkgdir ' .. pkgdir)

  exec ':lcd ' .. pkgdir
  const func_regex = 'git grep -n ' .. (isgitrepo ? '' : '--no-index') .. ' --no-recursive -P "(func( \([^)]+\))? |type |var |^	)' .. name .. '\b"'
  Debug('name ' .. name)
  Debug('func_regex ' .. func_regex)
  lexpr system(func_regex)
enddef

def! ShowLocalDef(word: string)
  const dir = expand('%:h')
  const regex = word .. '  *='
  const values = systemlist("git -C " .. dir .. " grep --max-depth 0 '" .. regex .. "'")
  if len(values) != 1
    echoerr "no match for regex '" .. regex .. "' in " .. dir .. " results: " .. join(values, ', ')
  endif
  const value = values[0]
  var vv = substitute(value, '.*= ', '', '')
  vv = substitute(vv, '"', '', 'g')
  @g = vv .. "\n"
  popup_atcursor(value, {})
enddef

def! ShowOrGotoDef()
  const word = expand('<cword>')
  if word =~? '^[a-z]*logtag[A-z]*$'
    g:ShowLocalDef(word)
  else
    # g:FindPackageFunction(expand('<cWORD>'))
    echom "set isk+=."
    set isk+=.
    var cword = expand('<cword>')
    set isk-=.
    try
      g:FindPackageFunction(cword, false)
    finally
    endtry
    #echom "set isk-"
    #set isk-=.
  endif
enddef

def! g:FindLocalConstantDefinition(identifier: string, Debug: func)
  echoerr "TODO FIXME FindLocalConstantDefinition()"
enddef

def! g:FindExportedConstantDefinition(identifier: string, Debug: func)
  echoerr "TODO FIXME exported"
enddef

def! FindConstantDefinition(cWORD: string, verbose: bool = false)
  var debug = 0
  if verbose || exists('b:debugFindConstantDefinition') && b:debugFindConstantDefinition
    debug = 1
  endif
  def Debug(text: string)
    if !debug
      return
    endif
    echom 'DEBUG: ' .. text
  enddef

  var fullname = substitute(cWORD, '^[(*&]\+\|(.*', '', '')
  fullname = substitute(fullname, '^!', '', '')
  if fullname !~ '\.'
    g:FindLocalConstantDefinition(cWORD, Debug)
    return
  endif
  g:FindExportedConstantDefinition(cWORD, Debug)
enddef

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

let g:cscope_xref_added = {}
function! MaybeSetCscopeXrefFile()
  if $CSCOPE_DB != ""
    cs add $CSCOPE_DB
    return
  endif

  let dir = GetCurrentFileDirOrCurrentDir()
  let cscopeXrefFile = dir . "/cscope.out"
  let pre_path = ''
  if IsManagedByGit(dir)
    let git_dir = GetGitDir(dir)
    let pre_path = fnamemodify(git_dir, ':h')
    let cscopeXrefFile = git_dir . "/cscope.out"
  endif

  if ! filereadable(cscopeXrefFile)
    return 0
  endif

  if empty(g:cscope_xref_added) || ! has_key(g:cscope_xref_added, cscopeXrefFile)
    exec 'cs add ' . cscopeXrefFile . ' ' . pre_path
    let g:cscope_xref_added[cscopeXrefFile] = 1
  endif
  return 1
endfun

function! NextErrorOrBuffer()
  if &diff
    normal ]c
    return
  endif

  if len(getloclist(0)) > 0
    lnext
  elseif len(getqflist()) > 0
    cnext
  elseif len(tabpagebuflist())[0] > 1
    bnext
  else
    normal l
  endif
endfun

function! PrevErrorOrBuffer()
  if &diff
    normal [c
    return
  endif

  if len(getloclist(0)) > 0
    lprev
  elseif len(getqflist()) > 0
    cprev
  elseif len(tabpagebuflist())[0] > 1
    bprev
  else
    normal h
  endif
endfun

function! GithubURL(sha1)
  if b:git_dir == ""
    echo "No b:git_dir?"
    return
  endif
  " Needs fugitive for b:git_dir
"echo 'system(' . "cd " . b:git_dir . "; gh -o " . a:sha1 . ')'
  call system(    "cd " . b:git_dir . "; gh -o " . a:sha1)
endfun

let g:race_setupdone = 0
function! ViewRace(prefix)
  if !g:race_setupdone
    sign define race text=>> texthl=Search
    let g:race_setupdone = 1
  end

	call search('^\s\+/' . a:prefix)
	normal F
  let w:race_view = 'top'
	exe ":sign place 2 line=" . line('.') . " name=race file=" . expand("%:p")
  normal j}
	call search('^\s\+/' . a:prefix)
	normal F
  let w:race_view = 'bottom'
	exe ":sign place 2 line=" . line('.') . " name=race file=" . expand("%:p")
	normal k

endfun

function! Diff(border)
  echo "border is " . a:border
  call search('^'.a:border, 'w')
  normal dG
  vert botright new
  normal PddGdd
  windo diffthis
endfun

function! CommitInfo(sha1)
  if len(a:sha1) == 0
    let sha1 = expand('<cword>')
    exec 'normal! diw'
  else
    let sha1 = a:sha1
  endif

  let msg = system("git show --no-patch --abbrev=10 --pretty='format:%h (%ci %an: %s)' " . sha1)
  exec "normal! a" . msg
endfun

function! StripWordBoundaryRegex(text)
  let text = substitute(a:text, '^\\<', '', '')
  let text = substitute(text, '\\>$', '', '')
  return text
endfun

function! GitNumberEdit(n)
  exec 'e ' .  GetStdout('git number list ' . a:n)[0]
endfun

function! GitBranch()
  let out = GetStdout("git symbolic-ref -q HEAD")
  if len(out) == 0
    return  ""
  end
  return out[0]
endfun

function! CodeSearch(cmd, word, in_file_dir = v:false)
  let needle = a:word
  if needle == ""
    let needle = expand('<cword>')
  endif
  let dir = '.'
  if a:in_file_dir| let dir = expand('%:h')| endif
  new
  if a:in_file_dir| exec 'lcd ' . dir| endif
  "lexpr system('cd ' . dir . ';' . a:cmd . ' ' . needle)
  lexpr system(a:cmd . ' ' . needle)
endfun

def! CheckSwap()
  var file = systemlist('file ' .. v:swapname)
  if len(file) < 1
    return
  endif
  var pid = substitute(file[0], '.*, pid ', '', '')
  pid = substitute(pid, ',.*', '', '')
  echo system("pstree -p " .. pid .. '|grep termname=')
enddef

def! New(path: string)
  var p = substitute(path, ':.*', '', 'g')
  exec 'new ' .. p
  var lnum = substitute(path, '[^:]*:', '', '')
  lnum = substitute(lnum, ':.*', '', '')
  call cursor(str2nr(lnum), 1)
enddef
