.PHONY: test lint build build_lint yamss

yamss: build build_lint

test:
	shellspec

build: lint
	rm -rf dist
	mkdir dist
	touch dist/yamss.sh
	cat tools/** > dist/yamss.sh
	cat lib/** >> dist/yamss.sh
	echo "setup\n" >> dist/yamss.sh

# excluding SC1091 because it attempts to follow `source`d files
# but source is used during machine setup, which don't run in dev
lint: test
	shellcheck --shell=bash --exclude=SC1091 lib/*.sh tools/*.sh

build_lint:
	shellcheck --shell=bash --exclude=SC1091 dist/yamss.sh

# This is what a fmt function _would_ look like
# but some of the formatting decisions don't make sense to me
# so I'm leaving it commented for now.
# format:
# 	shfmt -w -i 2 -ci -bn lib/* tools/*
