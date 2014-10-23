inoremap <buffer><expr> " mine#insertPair('"')
inoremap <buffer><expr> ' mine#insertPair("'")
inoremap <buffer><expr> [ mine#insertPair('[')
inoremap <buffer><expr> ( mine#insertPair('(')

inoremap <expr> { mine#insertBracket()
""inoremap ;; A;
inoremap <expr> ; mine#insertSemicolon()
inoremap <expr> <c-w> mine#deletePair()

"inoremap ,, A,
nnoremap <leader>; A;
nnoremap <leader>, A;
inoremap ,, /["')}\[\]]:nohla,
inoremap <expr>  ShiftCursorRight()
