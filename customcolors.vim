set termguicolors
"A " Omni completion
"hi Search ctermbg=33
"hi Search ctermbg=brown ctermfg=white
"hi Search ctermbg=17 ctermfg=white

"hi Search term=none cterm=none ctermbg=110 ctermfg=black guibg=brown guifg=white
hi Search term=none cterm=none ctermbg=110 ctermfg=black guibg=yellow guifg=black
hi CurSearch term=none cterm=none guifg=black guibg=rosybrown


hi pmenu ctermfg=black ctermbg=darkgray guibg=dimgray guifg=black
hi PmenuSel ctermfg=black ctermbg=gray guibg=green guifg=blue
" hi LineNr ctermfg=darkgray guifg=dimgray
hi LineNr ctermfg=248 ctermbg=18
" hi LineNr ctermbg=233 ctermfg=darkgray
hi LineNr ctermbg=0 ctermfg=darkgray guifg=dimgray

" These two are needed for CursorLineNr
set cursorlineopt=number
set cursorline
hi CursorLineNr cterm=none ctermbg=235 ctermfg=brown guifg=brown


"A " Color tryouts:
"A ":nmap j :exec ':hi comment ctermfg=' . (K + 1) . "\|let K = K + 1\|echo
"A "K"<CR>
"A ":nmap k :exec ':hi comment ctermfg=' . (K - 1) . "\|let K = K - 1\|echo
"A "K"<CR>

"hi folded ctermfg=darkgray ctermbg=black
hi folded guifg=darkgreen guibg=black cterm=bold

hi MatchParen cterm=underline ctermbg=none

hi SpellBad ctermfg=red ctermbg=none

"syn match braces "[{}]"
"hi braces ctermfg=darkgray

"hi StatusLine term=reverse ctermfg=blue ctermbg=white
"hi StatusLineNC ctermfg=darkgray ctermbg=black

hi TabLineSel term=underline cterm=underline ctermfg=black ctermbg=darkgreen guifg=black guibg=darkgreen
hi TabLine    term=underline cterm=underline ctermfg=black ctermbg=black                 guibg=black

hi quickfixregex term=none guibg=khaki guifg=mediumblue
hi visual guibg=black

" Highlights for text copied from kibana log
syn match Date '"\v(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d+, \d\d\d\d \@ \d\d:\d\d:\d\d\.\d\d\d \+\d\d:\d\d"'
hi Date ctermfg=green
syn match KibanaIPAddr '\<ip-\d\{1,3}\(-\d\{1,3}\)\{3}'
syn match DottedIPAddr '\<\d\{1,3}\(\.\d\{1,3}\)\{3}'
hi link DottedIPAddr KibanaIpAddr
hi KibanaIpAddr ctermfg=green
"    Message=foo bar baz
" Highlight  ^^^^^^^^^^^ only:
syn match KibanaText '[^"]' contained
syn match KibanaMessagePreamble 'Message=' contained
syn match KibanaMessage 'Message=[^"]*' contains=KibanaMessagePreamble,KibanaText
hi  KibanaText guifg=brown

hi SignColumn guibg=black
