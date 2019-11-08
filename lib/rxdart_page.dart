import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

/// 2. Вынесем счетчик за пределы виджета.
int _rxCounter = 10;

/// 3. Создадим евент.
final onCounterUpd = BehaviorSubject<int>();

/// 4. Вынесем инкремент за пределы виджета, добавим генерацию события.
Future incrementCounter() async {
  onCounterUpd.add(++_rxCounter);
}

/// 5.
class MyHomeRxPage extends StatelessWidget {
  final title;

  /// ! - Можно сделать константным классом
  const MyHomeRxPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 5. Иначе  - null
    onCounterUpd.add(_rxCounter);

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
            StreamBuilder<int>(
                initialData: onCounterUpd.value,
                stream: onCounterUpd,
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
                initialData: onCounterUpd.value,
                stream: onCounterUpd,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.display1,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
