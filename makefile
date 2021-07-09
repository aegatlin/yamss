.PHONY: test lint build build_lint yamss format format_tools format_lib

yamss: build build_lint

build: lint
	rm -rf dist
	mkdir dist
	touch dist/yamss.sh
	cat tools/** > dist/yamss.sh
	cat lib/** >> dist/yamss.sh
	echo "setup\n" >> dist/yamss.sh

lint: test
	shellcheck --shell=bash --exclude=SC1091 lib/*.sh tools/*.sh

test: format
	shellspec

format:
	shfmt -w -i 2 -ci -bn -sr lib/*
	shfmt -w -i 2 -ci -bn -sr tools/*

# excluding SC1091 because it attempts to follow `source`d files
# but source is used during machine setup, which don't run in dev

build_lint:
	shellcheck --shell=bash --exclude=SC1091 dist/yamss.sh
