import 'package:f_latte/bizmodels/counter_bm.dart';
import 'package:f_latte/bizmodels/counters_bm.dart';
import 'package:f_latte/bizmodels/sum_bm.dart';
import 'package:f_latte/core/sl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// приватная ссылка на синглтон [SumModel]
final _sumModel = sl<SumModel>();

class MyComplexHomeRxPage extends StatelessWidget {
  final title;
  final CountersModel countersModel;

  /// ! - Можно сделать константным классом
  const MyComplexHomeRxPage({Key key, this.title, this.countersModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(title),
        ),
        body: Column(
          children: <Widget>[
            Title(
              child: StreamBuilder<int>(
                  initialData: _sumModel.onUpd.value,
                  stream: _sumModel.onUpd,
                  builder: (context, snapshot) {
                    return Text(
                      'sum = ${snapshot.data}',
                      style: Theme.of(context).textTheme.title,
                    );
                  }),
              color: Colors.red,
            ),
            Container(
              height: 10,
            ),
            Center(
              child: StreamBuilder<List<CounterModel>>(
                  initialData: countersModel.onUpd.value,
                  stream: countersModel.onUpd,
                  builder: (context, snapshot) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(snapshot.data.length, (i) {
                        return Item(model: snapshot.data[i]);
                      }),
                    );
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: countersModel.addModel,
          tooltip: 'Add model',
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
        ));
  }
}

class Item extends StatelessWidget {
  final CounterModel model;

  const Item({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          StreamBuilder<int>(
              initialData: model.onCounterUpd.value,
              stream: model.onCounterUpd,
              builder: (context, snapshot) {
                return Text(
                  'local count: ${snapshot.data}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
          StreamBuilder<int>(
              initialData: model.onCountdownUpd.value,
              stream: model.onCountdownUpd,
              builder: (context, snapshot) {
                return RaisedButton(
                  child: Text('wait: ${snapshot.data}'),
                  onPressed: snapshot.data <= 0 ? model.incrementCounter : null,
                );
              }),
        ],
      ),
    );
  }
}
