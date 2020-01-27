default: build

build:
	echo "Building.."
	elm make src/Main.elm --output=main.js

build-opt:
	echo "Building with optimisations enabled..."
	elm make src/Main.elm --optimize --output=main.js

clean:
	rm -f *.js
	rm -rf ./elm-stuff/
	rm -rf ./dist/
	rm -rf  ./node_modules/

run: build
	chromium-browser --incognito ./index.html

dist: clean build-opt
	npm install uglify-js
	npm run minify
	mkdir ./dist
	cp ./main.min.js ./dist/main.js
	cp ./index.html ./dist
	cp -r ./assets ./dist/assets