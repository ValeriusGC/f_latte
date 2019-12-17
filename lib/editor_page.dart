import 'package:f_latte/editor_files/event.dart';
import 'package:f_latte/editor_files/list.dart';
import 'package:f_latte/editor_files/note.dart';
import 'package:f_latte/editor_list_progress_indicator.dart';
import 'package:f_latte/editor_page_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class EditorPage extends StatefulWidget {
  final EditorPageVm model;
  final String title;
  final HeroId heroIds;

  const EditorPage(
    this.model, {
    Key key,
    this.title,
    @required this.heroIds,
  }) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState
    extends State<EditorPage> /*with SingleTickerProviderStateMixin*/ {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

//  AnimationController _controller;
//  Animation<Offset> _animation;
  Event currEvent;
  EventType currEventType;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
          ),
          elevation: 1,
          title: StreamBuilder<int>(
              initialData: widget.model.onUidUpd.value,
              stream: widget.model.onUidUpd,
              builder: (context, snapshot) {
                final d = snapshot.data ?? 0;
                final t = '$d';
                return Text(t);
              }),
        ),
        body: _body(context),
      ),
      onWillPop: _readyToPop,
    );
  }

  Widget _body(BuildContext ctx) {
    return Container(
        color: Colors.orange[100],
        padding: EdgeInsets.only(left: 16, right: 16, top: 12),
        child: SafeArea(
          left: true,
          right: true,
          top: false,
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: EditableText(
                    onChanged: (str) => {},
                    controller: _titleController,
                    focusNode: _titleFocus,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    cursorColor: Colors.blue,
                    backgroundCursorColor: Colors.blue),
              ),
              Divider(thickness: 2.0, color: Colors.grey[500]),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: StreamBuilder<Event>(
                      initialData: widget.model.onEventUpd.value,
                      stream: widget.model.onEventUpd,
                      builder: (context, snapshot) {
                        print('_EditorPageState._body');
                        final d = snapshot.data;
                        if (d == null) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (d.type == EventType.note) {
                            return PlainNoteWidget(d);
                          } else if (d.type == EventType.list) {
                            return SomeListWidget(
                                widget.model, d, widget.heroIds);
                          } else {
                            return Center(
                              child: Text('???'),
                            );
                          }
                        }
                        return EditableText(
                          onChanged: (str) => {},
                          maxLines: 300,
                          // line limit extendable later
                          controller: _contentController,
                          focusNode: _contentFocus,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          backgroundCursorColor: Colors.red,
                          cursorColor: Colors.blue,
                        );
                      }),
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: StreamBuilder<EventType>(
                        initialData:
                            widget.model.onEventTypeUpd.value ?? EventType.note,
                        stream: widget.model.onEventTypeUpd,
                        builder: (context, snapshot) {
                          final d = snapshot.data;
                          return Icon(
                              d == EventType.note ? Icons.note : Icons.list);
                        }),
                    onPressed: () => widget.model.changeType(
                        widget.model.onEventTypeUpd.value == EventType.note
                            ? EventType.list
                            : EventType.note),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Future<bool> _readyToPop() async {
    SystemNavigator.pop();
    return true;
  }
}

class PlainNoteWidget extends StatelessWidget {
  final PlainNote _note;
  final _contentController = TextEditingController();
  final _contentFocus = FocusNode();

  PlainNoteWidget(this._note, {Key key}) : super(key: key) {
    _contentController.text = _note.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: EditableText(
        onChanged: (str) => {},
        maxLines: 300,
        // line limit extendable later
        controller: _contentController,
        focusNode: _contentFocus,
        style: TextStyle(color: Colors.black, fontSize: 20),
        backgroundCursorColor: Colors.red,
        cursorColor: Colors.blue,
      ),
    );
  }
}

class SomeListWidget extends StatelessWidget {
  final EditorPageVm _model;
  final SomeList _list;
  final HeroId _hero;
  final _contentController = TextEditingController();
  final _contentFocus = FocusNode();

  SomeListWidget(this._model, this._list, this._hero, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l2 = List.of(_list.items);
    l2.sort((e1, e2) {
      return e1.checked ? 1 : -1;
    });

    return Column(
      children: <Widget>[
        Hero(
          tag: _hero.progressId,
          child: StreamBuilder<int>(
              stream: _model.onProgressUpd,
              builder: (context, snapshot) {
                final v = snapshot.data ?? 0.0;
                return TaskProgressIndicator(
                  color: Colors.redAccent,
                  progress: v, // _model.getTaskCompletionPercent(_task),
                );
              }),
        ),
        Container(
          child: Expanded(
            child: ListView.separated(
              itemCount: l2.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  title: GestureDetector(
                    child: Text(
                      '${l2[index].rawText}',
                      style: TextStyle(
                        decoration: l2[index].checked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    onLongPress: () {
                      print('SomeListWidget.onLongPress');
                      _model.startEditElement(l2[index]);
                    },
                  ),
                  leading: Checkbox(
                    value: l2[index].checked,
                    onChanged: (bool value) {
                      _model.switchElement(l2[index], value);
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {},
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.red,
                );
              },
//            EntryItem(data[index]),
            ),
          ),
        ),
        StreamBuilder<ListElement>(
            stream: _model.onEditElementUpd,
            builder: (context, snapshot) {
              final d = snapshot.data;
              print('SomeListWidget.snapshot.data = $d');
              if (d == null) {
                return Container();
              } else {
                _contentController.text = d.rawText;
                return Column(
                  children: <Widget>[
                    Divider(thickness: 2.0, color: Colors.grey[500]),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: EditableText(
                              onChanged: (str) => {},
                              maxLines: 1,
                              // line limit extendable later
                              controller: _contentController,
                              focusNode: _contentFocus,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                              backgroundCursorColor: Colors.red,
                              cursorColor: Colors.blue,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.cached),
                            onPressed: () {
                              _model.stopEditElement(d, _contentController.text);
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 2.0, color: Colors.grey[500]),
                  ],
                );
              }
            }),
      ],
    );
  }
}
