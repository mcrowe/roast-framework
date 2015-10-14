build:
	coffee -o build/bundle.js -c src/*

watch:
	coffee -o build/bundle.js -w -c src/*