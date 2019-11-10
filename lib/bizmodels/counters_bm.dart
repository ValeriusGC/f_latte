import 'package:f_latte/bizmodels/counter_bm.dart';
import 'package:f_latte/bizmodels/sum_bm.dart';
import 'package:f_latte/core/sl.dart';
import 'package:rxdart/rxdart.dart';

/// Добавляет модель счетчика [CounterModel] в лист и подписывается на его обновления,
/// суммируя все и передавая в синглтон [SumModel]
class CountersModel {

  final _sum = sl<SumModel>();

  final items = <CounterModel>[];

  final BehaviorSubject<List<CounterModel>> onUpd;

  CountersModel.start() : this._();

  Future addModel() async {
    final item = CounterModel.start();
    item.onCounterUpd.listen((data){
      print('CountersModel.addModel: onCounterUpd.listen(($data)');
      _sum.update(items.fold(0, (a,b) => a + b.count));
    });
    items.add(item);
    onUpd.add(items);
  }

  Future dispose() async {
    await onUpd.close();
  }

  CountersModel._()
      : this.onUpd = BehaviorSubject.seeded([]);

}
