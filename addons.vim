if isdirectory("$HOME/.vim/daddons/vim-addon-manager")
    set runtimepath+=$HOME/.vim/daddons/vim-addon-manager
    call vam#ActivateAddons([
        \ 'sleuth',
        \ 'L9',
        \ 'AutoComplPop',
    \ ], {'auto_install' : 0})
endif
