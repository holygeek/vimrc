.PHONY: git_template

install:
	ln -sf `pwd`/bin/good ~/bin
	ln -sf `pwd`/bin/bad ~/bin
	ln -sf `pwd`/bin/vimcsearch ~/bin
	ln -sf `pwd`/bin/watchrss ~/bin
	ln -sf `pwd`/bin/gdb-bundle ~/bin
	ln -sf `pwd`/bin/git-picknote ~/bin
	ln -sf `pwd`/bin/vet2blame ~/bin
	ln -sf `pwd`/bin/vet ~/bin
	ln -sf `pwd`/bin/non-reentrant.sh ~/bin
	ln -sf `pwd`/bin/git-find-merge-base ~/bin
	ln -sf `pwd`/bin/vimcolors ~/bin/
	ln -sf `pwd`/bin/vimgrep ~/bin
	ln -sf `pwd`/bin/rss ~/bin
	for symname in vim view vimdiff viewdiff; do ln -sf `pwd`/bin/vi $$HOME/bin/$$symname; done
	for f in `bin/gsummary|tail -n +2|awk '{print $$1}'`; do ln -sf `pwd`/bin/$$f ~/bin; done
	ln -sf `pwd`/bin/git-branch.rc ~/bin
	ln -sf `pwd`/bin/vd ~/bin

repos:
	for d in $$(find . -depth '+1' -type d -name .git); do d=$${d%/.git}; echo $$d; git -C $$d remote -v;done > $@.txt

git_template:
	git config --global init.templatedir '~/.vim/git_template'
	git config --global alias.ctags '!.git/hooks/ctags'
where=.
install_git_hooks:
	ln -vs ~/.vim/git_template/hooks/post-* \
	       ~/.vim/git_template/hooks/ctags $(where)/.git/hooks
