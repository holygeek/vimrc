let s:cscope_xref_set = 0
if has("cscope")
  let s:cscope_xref_set =  MaybeSetCscopeXrefFile()
endif

if s:cscope_xref_set
  "set csprg=/usr/local/bin/cscope
  set csprg=/usr/bin/cscope
  set csto=0
  set cst
  set nocsverb
  " See :help csqf
  set cscopequickfix=s-,c-,d-,i-,t-,e-
  set csverb

  " Modified from :help cscope:
  " mnemonic : C-c is for cscope

  " 0 or s: Find this C symbol
  " 1 or g: Find this definition
  " 2 or d: Find functions called by this function
  " 3 or c: Find functions calling this function
  " 4 or t: Find this text string
  " 6 or e: Find this egrep pattern
  " 7 or f: Find this file
  " 8 or i: Find files #including this file

  nmap <leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>cg :cs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>ct :cs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>ce :cs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>cf :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <leader>ci :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <leader>cd :cs find d <C-R>=expand("<cword>")<CR><CR>


  " Using 'CTRL-c CTRL-w' then a search type makes the vim window
  " split horizontally, with search result displayed in
  " the new window.

  nmap <leader>cws :scs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>cwg :scs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>cwc :scs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>cwt :scs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>cwe :scs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>cwf :scs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <leader>cwi :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <leader>cwd :scs find d <C-R>=expand("<cword>")<CR><CR>

endif

