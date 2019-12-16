import 'package:f_latte/editor_files/note.dart';
import 'package:f_latte/editor_files/note_mngr.dart';
import 'package:f_latte/editor_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// instead of DI
final model = Model(PlainNote(10, 'one\ntwo\nthree'));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: EditorPage(model, title: 'Flutter Demo Editor', ),
    );
  }
}

