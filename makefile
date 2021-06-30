.PHONY: test lint build build_lint yamss

yamss: build build_lint

test:
	shellspec

build: lint
	rm -rf dist
	mkdir dist
	touch dist/yamss.sh
	cat lib/tools/** > dist/yamss.sh
	cat lib/lib.sh >> dist/yamss.sh
	echo "setup\n" >> dist/yamss.sh

lint: test
	shellcheck --shell=bash lib/lib.sh lib/tools/*

build_lint:
	shellcheck --shell=bash dist/yamss.sh

