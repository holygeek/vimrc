inoremap clg console.log();<esc>F)i

nmap <buffer> [[ :call search('\(function\\|\.createClass\)', 'bsW')<cr>
nmap <buffer> ]] :call search('\(function\\|\.createClass\)', 'sW')<cr>
