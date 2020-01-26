default: build

build:
	echo "Building.."
	elm make src/Main.elm --output=main.js

clean:
	rm -f *.js
	rm -rf ./elm-stuff/
	rm -rf ./dist/

run: build
	chromium-browser --incognito ./index.html

dist: clean build
	npm run minify
	mkdir ./dist
	cp ./main.min.js ./dist 