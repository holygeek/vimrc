"if &ft == 'go'
    "let g:ycm_global_ycm_extra_conf = resolve($HOME) . "/.ycm_my_extra_conf.py"
    let g:ycm_autoclose_preview_window_after_completion = 1
    "let g:ycm_confirm_extra_conf = 0
    let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
    let g:ycm_filetype_whitelist = { 'go': 1 }
    set rtp+=~/.vim/YouCompleteMe
"endif
