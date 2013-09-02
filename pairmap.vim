inoremap " ""i
inoremap ' ''i
inoremap [ []i
inoremap ( ()i
inoremap <expr> { mine#insertBracket()
""inoremap ;; A;
inoremap <expr> ; mine#insertSemicolon()
inoremap <expr> <c-w> mine#deletePair()

"inoremap ,, A,
nnoremap <leader>; A;
nnoremap <leader>, A;
inoremap ,, /["')}\[\]]:nohla,
inoremap  l%%a
