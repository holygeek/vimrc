if isdirectory(expand("$HOME/.vim/daddons/vim-addon-manager"))
    set runtimepath+=$HOME/.vim/daddons/vim-addon-manager
    call vam#ActivateAddons([])
    VAMActivate L9 AutoComplPop
    VAMActivate sleuth fugitive
    VAMActivate ManPageViewer@drchip

    let g:manpageview_winopen = "hsplit="

endif
