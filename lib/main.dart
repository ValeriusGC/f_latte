import 'package:f_latte/bizmodels/counters_bm.dart';
import 'package:f_latte/core/sl.dart';
import 'package:f_latte/rxdart_complex_page.dart';
import 'package:f_latte/rxdart_page.dart';
import 'package:f_latte/state_page.dart';
import 'package:flutter/material.dart';

void main() {
  setupLocatorRxModel();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Page with State'),
      home: MyComplexHomeRxPage(
        title: 'Flutter Demo for Maria',
        countersModel: sl<CountersModel>(),
      ),
    );
  }
}
