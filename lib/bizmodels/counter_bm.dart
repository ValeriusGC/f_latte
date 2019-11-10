import 'package:rxdart/rxdart.dart';

/// Модель счетчика, поведение  совпадает с [_Counter]
class CounterModel {
  int _count;

  /// Счетчик обратного отсчета
  int _countdown = 0;

  int get count => _count;

  CounterModel.start() : this._(0);

  Future init({int count}) async{

  }

  CounterModel._(this._count)
      : this.onCounterUpd = BehaviorSubject<int>.seeded(_count),
        this.onCountdownUpd = BehaviorSubject<int>.seeded(0);

  final BehaviorSubject<int> onCounterUpd;

  /// Евент обратного отсчета
  final BehaviorSubject<int> onCountdownUpd;

  /// Вынесем инкремент за пределы виджета, добавим генерацию события.
  Future incrementCounter() async {
    if (_countdown <= 0) {
      onCounterUpd.add(++_count);

      /// Запуск таймера, с вочдогом и генерацией евентов.
      _countdown = 3;
      onCountdownUpd.add(_countdown);
      Observable.periodic(Duration(seconds: 1), (_) => --_countdown)
          .take(3)
          .listen((e) => onCountdownUpd.add(_countdown));
    }
  }
}
