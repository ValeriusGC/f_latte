import 'package:f_latte/editor_files/note.dart';
import 'package:f_latte/editor_files/note_bm.dart';
import 'package:f_latte/editor_page.dart';
import 'package:f_latte/editor_page_vm.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// instead of DI
final model = EditorPageVm(NoteBm(PlainNote(
    10,
    ''
    'one\n'
    'two\n'
    'three\n'
    'four\n'
    'five\n'
    'six\n'
    'seven\n'
    'eight\n'
    'nine'
    '')));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: EditorPage(
        model,
        title: 'Flutter Demo Editor',
        heroIds: HeroId(progressId: 'progress_id_${10}'),
      ),
    );
  }
}
