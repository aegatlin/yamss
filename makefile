.PHONY: test

yamss: test
	rm -rf dist
	mkdir dist
	touch dist/yamss.sh
	cat lib/lib.sh > dist/yamss.sh
	echo "setup\n" >> dist/yamss.sh

test:
	shellspec
