import 'package:f_latte/editor_files/event.dart';
import 'package:f_latte/editor_files/note.dart';
import 'package:f_latte/editor_files/note_bm.dart';

class SomeList extends Event {
  final List<ListElement> items;

  SomeList(int uid, this.items) : super(uid, EventType.list);

  factory SomeList.fromPlainNote(PlainNote note) {
    final l = note.text.split('\n').toList();
    return SomeList(note.uid, l.map((e)=>ListElement(e, false)).toList());
  }

  void switchElement(ListElement element, bool check) {
    final e = items.firstWhere((e) => e.rawText == element.rawText, orElse: () => null);
    if(e != null) {
      final idx = items.indexOf(e);
      final e2 = ListElement(e.rawText, !e.checked);
      items.replaceRange(idx, idx+1, [e2]);
    }
  }

  void changeElement(ListElement element, String text) {
    final e = items.firstWhere((e) => e.rawText == element.rawText, orElse: () => null);
    if(e != null) {
      final idx = items.indexOf(e);
      final e2 = ListElement(text, e.checked);
      items.replaceRange(idx, idx+1, [e2]);
    }
  }

  void addElement(ListElement element) {
    items.add(element);
  }

}

class ListElement {
  final String rawText;
  final bool checked;
  

  ListElement(this.rawText, this.checked);
}


