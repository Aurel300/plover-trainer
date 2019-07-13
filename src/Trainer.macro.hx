import haxe.macro.Expr;

using StringTools;

/**
  Macro to load all the words from the `data/*.txt` files.
**/
class Trainer {
  public static macro function loadLessons(dir:String):Expr {
    var groups = [];
    var words = [];
    for (f in sys.FileSystem.readDirectory(dir)) {
      if (!f.endsWith(".txt")) continue;
      var lines = sys.io.File.getContent('${dir}/${f}').split("\n");
      for (l in lines) {
        if (l == "") continue;
        switch (l.charAt(0)) {
          case ">":
            var group = l.substr(1);
            groups.push(macro $v{group});
          case "'":
            var spl = l.split("': ");
            spl[0] = spl[0].substr(1);
            if (spl[1].endsWith(",")) spl[1] = spl[1].substr(0, spl[1].length - 1);
            words.push(macro {
              prompt: $v{spl[0]},
              chord: $v{spl[1]},
              group: $v{groups.length - 1}
            });
          case _:
            throw "!";
        }
      }
    }
    return macro {
      groups: $a{groups},
      words: $a{words}
    };
  }
}
