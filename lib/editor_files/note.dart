import 'package:f_latte/editor_files/note_mngr.dart';

class Event {
  final int uid;
  final EventType type;

  Event(this.uid, this.type);

}

class PlainNote extends Event {

  final String text;

  PlainNote(int uid, this.text) : super(uid, EventType.note);

  factory PlainNote.fromSomeList(SomeList list) {
    return PlainNote(list.uid, list.items.map((e) => e.text).join('\n'));
  }

}

class SomeList extends Event {
  final List<ListElement> items;

  SomeList(int uid, this.items) : super(uid, EventType.list);

  factory SomeList.fromPlainNote(PlainNote note) {
    final l = note.text.split('\n').toList();
    print('SomeList.fromPlainNote: l = $l');
    return SomeList(note.uid, l.map((e)=>ListElement(e)).toList());
  }

}

class ListElement {
  final String text;

  ListElement(this.text);
}


// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry('Chapter A',
    <Entry>[
      Entry('Section A0',
        <Entry>[
          Entry('Item A0.1'),
          Entry('Item A0.2'),
          Entry('Item A0.3'),
        ],
      ),
      Entry('Section A1'),
      Entry('Section A2'),
    ],
  ),
  Entry('Chapter B',
    <Entry>[
      Entry('Section B0'),
      Entry('Section B1'),
    ],
  ),
  Entry('Chapter C',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry('Section C2',
        <Entry>[
          Entry('Item C2.0'),
          Entry('Item C2.1'),
          Entry('Item C2.2'),
          Entry('Item C2.3'),
        ],
      ),
    ],
  ),
];