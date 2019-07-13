# plover-trainer

Basic word trainer for [Plover](https://github.com/openstenoproject/plover), usable in the browser. Made in [Haxe](https://github.com/HaxeFoundation/haxe) (4.0.0+), compiled to JavaScript.

## Building

```bash
# build the project
haxe make.hxml
# build the stylesheet
(cd assets; ./gen-scss.sh)
```

## Running

Open `bin/index.html` in a browser.

_For correct input detection, make sure to set the spaces to appear after the word._

## TODO

 - add the remaining lessons to `data`
 - customisable modes
   - timer length / disable
 - sounds
 - auto-parse the `main.json` dictionary from Plover for drilling all the words (not lesson-based)
