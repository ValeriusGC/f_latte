import 'package:rxdart/rxdart.dart';

class SumModel {
  int _sum;

  final onUpd = BehaviorSubject.seeded(0);

  void update(int i) {
    onUpd.add(i);
  }

  Future dispose() async {
    await onUpd.close();
  }

}
