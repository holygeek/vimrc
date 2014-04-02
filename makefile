.PHONY: git_template

install:
	ln -s `pwd`/bin/good ~/bin
	ln -s `pwd`/bin/bad ~/bin

git_template:
	git config --global init.templatedir '~/.vim/git_template'
	git config --global alias.ctags '!.git/hooks/ctags'
where=.
install_git_hooks:
	ln -vs ~/.vim/git_template/hooks/post-* \
	       ~/.vim/git_template/hooks/ctags $(where)/.git/hooks
