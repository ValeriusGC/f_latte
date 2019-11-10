import 'package:f_latte/bizmodels/counter_bm.dart';
import 'package:f_latte/bizmodels/counters_bm.dart';
import 'package:f_latte/bizmodels/sum_bm.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupLocatorRxModel() {
  /// Ленивый синглтон
  sl.registerLazySingleton(() => SumModel());
  /// Ленивый синглтон
  sl.registerLazySingleton(() => CountersModel.start());
  /// Фабрика объектов
  sl.registerFactory(() => CounterModel.start());
}
