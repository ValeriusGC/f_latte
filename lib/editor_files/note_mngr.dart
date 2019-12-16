import 'package:f_latte/editor_files/note.dart';
import 'package:rxdart/rxdart.dart';

class Storage {
  final items = <int, Event>{};
}

enum EventType {note, list}

class Model {

  final onEventUpd = BehaviorSubject<Event>();
  final onEventTypeUpd = BehaviorSubject<EventType>();

  final onUidUpd = BehaviorSubject<int>();

  final _event = <Event>[null];

  set event(Event value) => _event[0] = value;

  Event get event => _event[0];

  Model(Event event) {
    this._event[0] = event;
    onEventUpd.add(event);
    onEventUpd.distinct().listen((ev){
      onUidUpd.add(ev.uid);
      onEventTypeUpd.add(ev.type);
    });

  }

  void changeType(EventType type) {
    switch(type) {
      case EventType.note:
        if(event is SomeList) {
          event = PlainNote.fromSomeList(event);
        }
        break;
      case EventType.list:
        if(event is PlainNote) {
          event = SomeList.fromPlainNote(event);
        }
    }
    onEventUpd.add(event);
  }


}