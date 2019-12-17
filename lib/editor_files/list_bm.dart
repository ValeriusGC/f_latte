import 'package:f_latte/editor_files/event.dart';
import 'package:f_latte/editor_files/list.dart';
import 'package:rxdart/rxdart.dart';

class ListBm implements EventBm{

  final onEventUpd = BehaviorSubject<Event>();
  final onEditElementUpd = BehaviorSubject<ListElement>();

  final _list = <SomeList>[null];
  final _editIdx = <int>[-1];

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

  /// Фиксируем элемент для редактирования
  void startEditElement(ListElement element) {
    final idx = _list[0].items.indexOf(element);
    _editIdx[0] = idx;
    if(idx > -1){
      onEditElementUpd.add(element);
    }
  }

  void stopEditElement(ListElement element, String newText) {
    if(_editIdx[0] != -1){
      _list[0].changeElement(element, newText);
      onEventUpd.add(_list[0]);
    }
    onEditElementUpd.add(null);
  }

}