using StringTools;
using BrowserTools;

/**
  Main class, responsible for browser events and UI control.
**/
class Main {
  /**
    How many frames to wait until the letters are shown on the keyboard.
  **/
  static inline final FRAMES_LETTERS = 60 * 3;

  /**
    How many frames to wait until the correct chord for the word is revealed.
  **/
  static inline final FRAMES_CHORD = 60 * 8;

  /**
    If `true`, the timer will not tick down. Should only be `false` when the
    input element is focused.
  **/
  public static var paused:Bool = true;

  /**
    Per-tick logic. Updates the timer, shows letters or chords once needed.
  **/
  static function tick(delta:Float):Void {
    if (!paused) {
      if (Trainer.status.word == null)
        nextWord();
      Trainer.status.shownFor++;
      "timer".id().style.width = '${(1 - (Trainer.status.shownFor / FRAMES_CHORD)) * 100}%';
      // "timer".id().style.opacity = '${0.3 + 0.7 * (Trainer.status.shownFor / FRAMES_CHORD)}';
      if (Trainer.status.shownFor == FRAMES_LETTERS)
        "hint".id().clAdd("show-letters");
      if (Trainer.status.shownFor == FRAMES_CHORD) {
        for (key in Steno.order(Trainer.status.word.chord)) {
          "hint".id().qs('[data-steno="${key}"]').clAdd("hint");
        }
      }
    }
    js.Browser.window.requestAnimationFrame(tick);
  }

  /**
    Selects the next word in the trainer state and display it.
    Resets the visuals.
  **/
  static function nextWord():Void {
    var word = Trainer.nextWord();
    if (word == null) {
      paused = true;
      return;
    }
    "status".id().innerText = Trainer.lessons.groups[word.group];
    "prompt".id().innerText = word.prompt;
    "hint".id().clRemove("show-letters");
    "timer".id().style.width = "100%";
    for (e in "hint".id().qsa(".hint"))
      e.clRemove("hint");
  }

  /**
    Checks if the entered word is correct.
    If yes, `nextWord` is called.
    Either way the input is cleared.
  **/
  static function checkInput():Void {
    var el = "answer".id().input();
    var v = el.value;
    if (!v.endsWith(" ") || Trainer.status.word == null)
      return;
    if (v.trim() == Trainer.status.word.prompt) {
      // +1
      nextWord();
    } else {
      // -1?
    }
    el.value = "";
  }

  /**
    Entry point.
  **/
  public static function main():Void {
    // initialise lessons
    Trainer.init();
    "lesson-select".id().innerHTML = [
      for (group in Trainer.lessons.groups)
        '<label><input type="checkbox" checked data-group="${group}"> ${group}</label>'
    ].join("<br>");
    for (e in "lesson-select".id().qsa("input")) {
      var el = e.input();
      el.addEventListener("change", () -> Trainer.selectedGroups[el.getAttribute("data-group")] = el.checked);
    }

    // event listeners
    "controls-skip".id().addEventListener("click", () -> nextWord());
    "controls-none".id().addEventListener("click", () -> {
      for (lesson in Trainer.lessons.groups)
        Trainer.selectedGroups[lesson] = false;
      for (e in "lesson-select".id().qsa("input"))
        e.input().checked = false;
    });
    "controls-all".id().addEventListener("click", () -> {
      for (lesson in Trainer.lessons.groups)
        Trainer.selectedGroups[lesson] = true;
      for (e in "lesson-select".id().qsa("input"))
        e.input().checked = true;
    });
    "answer".id().addEventListener("focus", () -> paused = false);
    "answer".id().addEventListener("blur", () -> paused = true);
    "answer".id().addEventListener("keyup", checkInput);
    js.Browser.window.requestAnimationFrame(tick);
  }
}
