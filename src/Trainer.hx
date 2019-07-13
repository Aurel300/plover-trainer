/**
  Abstract state of the trainer, including the words for all lessons.
**/
class Trainer {
  /**
    All loaded lessons.
    `groups` represent the sub-titles of lessons.
    `words` represent all words in a single array; see `Word` typedef below.
  **/
  public static var lessons:{groups:Array<String>, words:Array<Word>};

  /**
    Map of active groups. When `selectedGroups["some group name"]` is true,
    the words of that group will be shown to the user.
  **/
  public static var selectedGroups:Map<String, Bool>;

  /**
    Currently shown word, and how many ticks it has been shown for.
  **/
  public static var status = {
    word: (null : Word),
    shownFor: 0
  };

  /**
    Stub for the `loadLessons` method in `Trainer.macro.hx`.
  **/
  public static macro function loadLessons() {}

  /**
    Load lessons, select all groups initially.
  **/
  public static function init():Void {
    lessons = loadLessons("../data");
    selectedGroups = [for (group in lessons.groups) group => true];
  }

  /**
    Try to select the next word. Make sure it is not the same as the last one,
    and that the group of the selected word is enabled.
  **/
  public static function nextWord():Word {
    var ret = null;
    var sgc = 0;
    for (g in Trainer.selectedGroups)
      if (g)
        sgc++;
    if (sgc == 0)
      return null;
    // FIXME: this is a pretty crappy method
    do {
      ret = Trainer.lessons.words[Std.int(Math.random() * Trainer.lessons.words.length)];
    } while (ret == status.word || !selectedGroups[Trainer.lessons.groups[ret.group]]);
    status.word = ret;
    status.shownFor = 0;
    return ret;
  }
}

typedef Word = {
  // the textual representation of the word
  prompt:String,
  // the steno chord for the word
  chord:String,
  // the index of the group (in the `lessons.groups` array) for this word
  group:Int
};
