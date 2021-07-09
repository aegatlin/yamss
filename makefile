.PHONY: test lint build build_lint yamss format format_tools format_lib

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

format: format_tools format_lib

format_tools:
	shfmt -w -i 2 -ci -bn -sr tools/*

format_lib:
	shfmt -w -i 2 -ci -bn -sr lib/*
