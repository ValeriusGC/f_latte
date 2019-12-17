import 'package:f_latte/editor_files/note_bm.dart';
import 'package:rxdart/rxdart.dart';

class Event {
  final int uid;
  final EventType type;

  Event(this.uid, this.type);

}

enum EventType {note, list}


abstract class EventBm{
  BehaviorSubject get onEventUpd;
  Event get event;
}