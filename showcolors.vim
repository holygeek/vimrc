vim9script
set nowrap
set laststatus=0
set noruler
set buftype=nofile


nnoremap Q :qa<cr>
normal G

var sy = []
var hi = []
var win_height = winheight(0)
for [name, rgb] in items(v:colornames)
	if stridx(name, ' ') >= 0|continue|endif
	add(sy, "syn match " .. name .. " '\\<" .. name .. "\\>'")
	add(hi, "hi " .. name .. " guifg=" .. rgb)
endfor

append('$', sy)
append('$', hi)
silent normal ggddyG
:@0
silent :g/^hi /d
silent :%s/syn match \(\w\+\) .*/\1/
#silent :g/^gr[ea]y\d\d\+$/d

# blue brown cyan gray green grey maroon orange pink purple red violet white yellow
# var colornames = getline(1, '$')
# echomsg colornames
# TODO sort color using sort({list} [, {func} [, {dict}]])
#	When {func} is a |Funcref| or a function name, this function
#	is called to compare items.  The function is invoked with two
#	items as argument and must return zero if they are equal, 1 or
#	bigger if the first one sorts after the second one, -1 or
#	smaller if the first one sorts before the second one.
#		func MyCompare(i1, i2)
#		   return a:i1 == a:i2 ? 0 : a:i1 > a:i2 ? 1 : -1
#		endfunc
#		eval mylist->sort("MyCompare")


silent :%!sort

# DEBUG add test lines for catching off-by-one error
#appendbufline('', '$', ['TEST', 'TEST2', 'TEST3'])
var ncolors = line('$')
var ncolumns = float2nr(floor(ncolors / win_height))
# DEBUG echomsg 'A ncolors ' .. ncolors .. ' win_height ' .. win_height .. ' ncolumns ' .. ncolumns .. ' baki ' .. (ncolors % win_height)
if ncolors % win_height > 0
	ncolumns += 1
endif
# DEBUG echomsg 'B ncolors ' .. ncolors .. ' win_height ' .. win_height .. ' ncolumns ' .. ncolumns
hi vertsplit ctermbg=none ctermfg=black gui=none

set nonu nornu
const cmd_jump = 'normal ' .. (win_height) .. 'jzt'
for i in range(ncolumns - 1)
	:vsp|wincmd l
	exec cmd_jump
endfor

win_gotoid(1001)
