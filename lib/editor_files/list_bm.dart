import 'package:f_latte/editor_files/event.dart';
import 'package:f_latte/editor_files/list.dart';
import 'package:f_latte/editor_files/note.dart';
import 'package:rxdart/rxdart.dart';

class ListBm implements EventBm{

  final onEventUpd = BehaviorSubject<Event>();

  final _list = <SomeList>[null];

  @override
  SomeList get event => _list[0];

  ListBm(SomeList list) {
    _list[0] = list;
    onEventUpd.add(_list[0]);
  }

  void switchElement(ListElement element, bool check) {
    _list[0].switchElement(element, check);
    onEventUpd.add(_list[0]);
  }

  void addElement(ListElement element) {
    _list[0].addElement(element);
    onEventUpd.add(_list[0]);
  }

}