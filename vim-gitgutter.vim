" Source this file to customize vim-gitgutter plugin
"
"au BufReadPost ~/.vim/**,~/wmgr/**,~/.shell/** call MyGutterToggle()
"nnoremap <leader>? :call MyGutterToggle()<cr>

" Get original highlighting for diff mode
let s:Diff = {
  \ 'Add'    : GetHighlightAttrs('DiffAdd'),
  \ 'Change' : GetHighlightAttrs('DiffChange'),
  \ 'Delete' : GetHighlightAttrs('DiffDelete'),
  \ }

function! MyGutterToggle()
  GitGutterToggle
  GitGutterLineHighlightsEnable
  if g:gitgutter_enabled
    " hi DiffAdd ctermbg=236
    " Maroon: 131
    "hi DiffAdd    ctermbg=236 guibg=#303030
    "hi DiffChange ctermbg=236 guibg=#303030
    "hi DiffDelete ctermbg=236 guibg=#303030
    nmap [c :GitGutterPrevHunk<cr>
    nmap ]c :GitGutterNextHunk<cr>
  else
    " Restore the original colors
    "exe "hi DiffAdd    ctermbg=" . get(s:Diff['Add'   ], 'ctermbg', 'none')
    "exe "hi DiffChange ctermbg=" . get(s:Diff['Change'], 'ctermbg', 'none')
    "exe "hi DiffDelete ctermbg=" . get(s:Diff['Delete'], 'ctermbg', 'none')
    nunmap [c
    nunmap ]c
  endif
endfun


