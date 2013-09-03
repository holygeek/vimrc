.PHONY: git_template
git_template:
	git config --global init.templatedir '~/.vim/git_template'
	git config --global alias.ctags '!.git/hooks/ctags'
where=.
install_git_hooks:
	cp -v -i ~/.vim/git_template/hooks/* $(where)/.git/hooks
