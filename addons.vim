if isdirectory(expand("$HOME/.vim/daddons/vim-addon-manager"))
    set runtimepath+=$HOME/.vim/daddons/vim-addon-manager
    call vam#ActivateAddons([])
    "VAMActivate L9 AutoComplPop
    VAMActivate sleuth fugitive
    VAMActivate ManPageViewer@drchip
    VAMActivate vim-bracketed-paste
    VAMActivate surround
    VAMActivate MPage
    VAMActivate dbext
    "VAMActivate SQLUtilities " Requires Dr. Chip's Align.vim, but Align.vim messes up insert mode

    let g:manpageview_winopen = "hsplit="

endif

let g:fugitive_gitlab_domains = ['https://gitlab.myteksi.net']
