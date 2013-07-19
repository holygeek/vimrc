function! ShowDetails()
  exec "normal yyp0f D0y$Idpkg -l A;apt-cache show p!!sh"
endfunction

function! GetPackageName(line)
  let packageName = split(a:line)[0]
  echo "packageName is ".packageName
  return packageName
endfunction

function! GetPackageLine()
  let lnum = search('^[a-z]', 'bcnW')
  return getline(lnum)
endfunction

function! InstallPackage(packageName)
  echo "installing " . a:packageName . " ..."
  if strlen(a:packageName) == 0
    echo "No package to install."
    return
  endif

  exec ":!echo aptitude install " . a:packageName . "; sudo aptitude install " . a:packageName
endfunction

function! IsPackageLine(line)
  return match(a:line, '^[a-z]') == 0
endfunction

function! Install()
  let curr_line = getline('.')
  if IsPackageLine(curr_line)
   call InstallPackage(GetPackageName(curr_line))
  else
   call InstallPackage(GetPackageName(GetPackageLine()))
  endif
endfunction

nnoremap <buffer> l :call ShowDetails()<CR>
nmap <buffer> h u
nmap <buffer> i :call Install()<CR>
nnoremap <buffer> q :q!<CR>

syn match Description '^Description: '
syn match OneLineDescription '^Description: .*' contains=Description
syn match DetailDescription '^ .*'
syn match Package '^Package: .*'
syn match PackageName '^[a-z0-9][^ ]\+ '
syn match PackageSize '^Size: \d\+'
syn match PackageInstalledSize '^Installed-Size: \d\+'

hi PackageName ctermfg=green
hi PackageSize ctermfg=yellow
hi PackageInstalledSize ctermfg=yellow
hi link Description Comment
hi DetailDescription ctermfg=yellow
hi OneLineDescription ctermfg=green
hi link Package OneLineDescription
