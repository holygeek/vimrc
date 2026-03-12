"let g:lsp_settings_root_markers = ['.git', '.git/']
"let g:lsp_log_file="lsp.log"
"let g:lsp_log_verbose = 1

call plug#begin()

Plug 'tpope/vim-abolish'

" :r!ls --color -l
" :ColorHighlight
Plug 'chrisbra/Colorizer'

Plug 'mattn/calendar-vim'
let g:calendar_diary=$HOME.'/dev/.diary'
let g:calendar_monday = 1

Plug 'AndrewRadev/undoquit.vim'

"Plug 'itchyny/calendar.vim'
"source ~/dev/.cache/calendar.vim/credentials.vim
"let g:calendar_google_calendar = 1
"let g:calendar_google_task = 1

call plug#end()

" :help LspCodeActionText
" Wed Apr  9 14:15:09 +08 2025
"let g:lsp_document_code_action_signs_enabled = 0
"let g:lsp_auto_enable = 0
