import 'package:f_latte/editor_files/event.dart';
import 'package:f_latte/editor_files/list.dart';
import 'package:f_latte/editor_files/note_bm.dart';

class PlainNote extends Event {

  final String text;

  PlainNote(int uid, this.text) : super(uid, EventType.note);

  factory PlainNote.fromSomeList(SomeList list) {
    return PlainNote(list.uid, list.items.map((e) => e.rawText).join('\n'));
  }

}

