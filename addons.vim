if isdirectory(expand("$HOME/.vim/daddons/vim-addon-manager"))
    set runtimepath+=$HOME/.vim/daddons/vim-addon-manager
    call vam#ActivateAddons([])
    VAMActivate L9 AutoComplPop
    VAMActivate sleuth fugitive
    VAMActivate ManPageViewer@drchip
    VAMActivate vim-bracketed-paste
    VAMActivate surround
    VAMActivate MPage

    let g:manpageview_winopen = "hsplit="

endif
