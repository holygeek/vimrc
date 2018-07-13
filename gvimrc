:nmap + :let &guifont=substitute(&guifont, '\d\+$', '\=submatch(0) + 1', '')<cr>
:nmap - :let &guifont=substitute(&guifont, '\d\+$', '\=submatch(0) - 1', '')<cr>
