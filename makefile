.PHONY: git_template

install:
	ln -sf `pwd`/bin/good ~/bin
	ln -sf `pwd`/bin/bad ~/bin
	ln -sf `pwd`/bin/vimcsearch ~/bin
	ln -sf `pwd`/bin/watchrss ~/bin
	ln -sf `pwd`/bin/gdb-bundle ~/bin
	ln -sf `pwd`/bin/git-picknote ~/bin
	ln -sf `pwd`/bin/vet ~/bin
	for symname in vim view vimdiff viewdiff; do ln -sf `pwd`/bin/vi $$HOME/bin/$$symname; done

git_template:
	git config --global init.templatedir '~/.vim/git_template'
	git config --global alias.ctags '!.git/hooks/ctags'
where=.
install_git_hooks:
	ln -vs ~/.vim/git_template/hooks/post-* \
	       ~/.vim/git_template/hooks/ctags $(where)/.git/hooks
