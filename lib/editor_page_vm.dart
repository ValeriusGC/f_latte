import 'package:f_latte/editor_files/event.dart';
import 'package:f_latte/editor_files/list.dart';
import 'package:f_latte/editor_files/list_bm.dart';
import 'package:f_latte/editor_files/note.dart';
import 'package:f_latte/editor_files/note_bm.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class HeroId {
  final String progressId;
//  final String titleId;
//  final String codePointId;
//  final String remainingTaskId;

  HeroId({
    @required this.progressId,
//    @required this.titleId,
//    @required this.codePointId,
//    @required this.remainingTaskId,
  });
}


class EditorPageVm {

  final onEventUpd = BehaviorSubject<Event>();

  final onEventTypeUpd = BehaviorSubject<EventType>();

  final onUidUpd = BehaviorSubject<int>();

  final onProgressUpd = BehaviorSubject<int>();

  final onEditElementUpd = BehaviorSubject<ListElement>();
//  final _event = <Event>[null];

  final _eventBm = <EventBm>[null];

//  set event(Event value) => _eventBm[0] = value;
//
//  Event get event => _event[0];

  EditorPageVm(EventBm bm) {
    _eventBm[0] = bm;

    _eventBm[0].onEventUpd.listen((ev){
      _evChange(ev);
//      print('EditorPageVm.EditorPageVm.1');
//      onEventUpd.add(ev);
//      if(ev is SomeList){
//        print('EditorPageVm.EditorPageVm');
//        final items = ev.items;
//        final completed = items.where((e) => e.checked).length;
//        final perc = (completed / items.length * 100).toDouble();
//        onProgressUpd.add(perc);
//      }
    });

    onEventUpd.distinct().listen((ev){
      onUidUpd.add(ev.uid);
      onEventTypeUpd.add(ev.type);
    });

  }

  void switchElement(ListElement element, bool check) {
    if(_eventBm[0] is ListBm){
      (_eventBm[0] as ListBm).switchElement(element, check);
    }
  }

  void addElement(ListElement element) {
    if(_eventBm[0] is ListBm){
      (_eventBm[0] as ListBm).addElement(element);
    }
  }

  void startEditElement(ListElement element) {
    if(_eventBm[0] is ListBm){
      (_eventBm[0] as ListBm).startEditElement(element);
    }
  }

  void stopEditElement(ListElement element, String newText) {
    if(_eventBm[0] is ListBm){
      (_eventBm[0] as ListBm).stopEditElement(element, newText);
    }
  }

  void changeType(EventType type) {

    _eventBm[0].onEventUpd.close();

    switch(type) {
      case EventType.note:
        if(_eventBm[0] is ListBm) {
          _eventBm[0] = NoteBm(PlainNote.fromSomeList(_eventBm[0].event));
        }
        break;
      case EventType.list:
        if(_eventBm[0] is NoteBm) {
          _eventBm[0] = ListBm(SomeList.fromPlainNote(_eventBm[0].event));
        }
    }

    // переобулись
    _eventBm[0].onEventUpd.listen((ev){
      _evChange(ev);
    });
    if(_eventBm[0] is ListBm) {
      (_eventBm[0] as ListBm).onEditElementUpd.listen((ev){
        onEditElementUpd.add(ev);
      });
    }

  }

  void _evChange(Event ev){
    onEventUpd.add(ev);
    if(ev is SomeList){
      print('EditorPageVm.EditorPageVm');
      final items = ev.items;
      final completed = items.where((e) => e.checked).length;
      final perc = (completed / items.length * 100).toInt();
      onProgressUpd.add(perc);
    }
  }

}