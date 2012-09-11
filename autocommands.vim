" Return cursor back to where it was if we reopen a recent file
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif 
au BufReadPost ~/.shell/* set ft=sh
