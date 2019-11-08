import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class _Counter {
  int _count;
  /// Счетчик обратного отсчета
  int _countdown = 0;

  int get count => _count;

  _Counter(this._count)
      : this.onCounterUpd = BehaviorSubject<int>.seeded(_count),
        this.onCountdownUpd = BehaviorSubject<int>.seeded(0);

  final BehaviorSubject<int> onCounterUpd;

  /// Евент обратного отсчета
  final BehaviorSubject<int> onCountdownUpd;

  /// Вынесем инкремент за пределы виджета, добавим генерацию события.
  Future incrementCounter() async {
    if(_countdown <= 0) {
      onCounterUpd.add(++_count);
      /// Запуск таймера, с вочдогом и генерацией евентов.
      _countdown = 3;
      onCountdownUpd.add(_countdown);
      Observable
          .periodic(Duration(seconds: 1), (_) => --_countdown)
          .take(3)
          .listen((e) => onCountdownUpd.add(_countdown));
    }
  }
}

final _counter = _Counter(5);

///
class MyHomeRxPage extends StatelessWidget {
  final title;

  /// ! - Можно сделать константным классом
  const MyHomeRxPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// Реактивная надпись
            StreamBuilder<int>(
                stream: _counter.onCountdownUpd,
                builder: (context, snapshot) {
                  return Text(
                    'Rest ${snapshot.data} seconds',
                    style: Theme.of(context).textTheme.title,
                  );
                }),
            StreamBuilder<int>(
                stream: _counter.onCounterUpd,
                builder: (context, snapshot) {
                  return Text(
                    'You have pushed the button ${snapshot.data} times:',
                  );
                }),
//            Text(
//              'You have pushed the button this many times:',
//            ),
            /// 6.
            StreamBuilder<int>(
                stream: _counter.onCounterUpd,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.display1,
                  );
                }),
          ],
        ),
      ),
      /// Кнопка стала реактивной
      floatingActionButton: StreamBuilder<int>(
        initialData: _counter.onCountdownUpd.value,
        stream: _counter.onCountdownUpd,
        builder: (context, snapshot) {
          return FloatingActionButton(
            onPressed: snapshot.data <= 0 ? _counter.incrementCounter : null,
            tooltip: 'Increment',
            backgroundColor: snapshot.data <= 0
                ? Theme.of(context).primaryColor
                : Colors.grey,
            child: Icon(Icons.add),
          );
        }
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
