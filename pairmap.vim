inoremap " ""i
inoremap ' ''i
inoremap [ []i
inoremap ( ()i
inoremap <expr> { mine#insertBracket()
""inoremap ;; A;
inoremap <expr> ; mine#insertSemicolon()

"inoremap ,, A,
nnoremap <leader>; A;
nnoremap <leader>, A;
inoremap ,, /["')}\[\]]:nohla,
inoremap  /["')}\[\]]:nohla
