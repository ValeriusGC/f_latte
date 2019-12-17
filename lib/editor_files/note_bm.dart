import 'package:f_latte/editor_files/event.dart';
import 'package:f_latte/editor_files/note.dart';
import 'package:rxdart/rxdart.dart';

class NoteBm  implements EventBm{

  final onEventUpd = BehaviorSubject<PlainNote>();

  final PlainNote _note;

  @override
  PlainNote get event => _note;

  NoteBm(this._note) {
    onEventUpd.add(_note);
  }

}