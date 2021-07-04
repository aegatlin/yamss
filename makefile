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
	cat lib/utils.sh >> dist/yamss.sh
	echo "setup\n" >> dist/yamss.sh

# excluding SC1091 because it attempts to follow `source`d files
# but source is used during machine setup, which don't run in dev
lint: test
	shellcheck --shell=bash --exclude=SC1091 lib/lib.sh lib/tools/*

build_lint:
	shellcheck --shell=bash --exclude=SC1091 dist/yamss.sh

