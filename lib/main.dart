import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:simple_animations/simple_animations/multi_track_tween.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Press to calc'),
              onPressed: () {
                showCalcModalBottomSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds ModalBottomSheet for calcs
void showCalcModalBottomSheet(BuildContext ctx) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isDismissible: false,
    isScrollControlled: true,
    context: ctx,
    builder: (ctx) {
      return BottomSheet();
    },
  );
}

const bottomHeight = 0.5;

///
class BottomSheet extends StatelessWidget {
  final TextEditingController scanController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();

  BottomSheet({Key key}) : super(key: key) {
    scanController.addListener(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
    scanController.text = onTextChange.value ?? 'Start';
    scanController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: scanController.text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * bottomHeight,
//      color: Colors.green,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimContainer(),
//            Container(
//              decoration: const BoxDecoration(
//                color: Colors.white,
//              ),
//              child: StreamBuilder<String>(
////                initialData: onTextChange.value,
//                stream: onTextChange,
//                builder: (context, snapshot) {
//                  final d = snapshot.data;
//                  if(d!=null){
//                    print('BottomSheet.build');
//                    scanController.text = d;
//                    scanController.selection = TextSelection
//                        .collapsed(offset: scanController.text.length);
//                  }
//                  return TextField(
////                focusNode: myFocusNode,
//                    controller: scanController,
//                    autofocus: true,
//                    onTap: () {
//                      SystemChannels.textInput.invokeMethod('TextInput.hide');
//                    },
//                    onEditingComplete: () {
//                      SystemChannels.textInput.invokeMethod('TextInput.hide');
//                    },
//                    onChanged: (s) => onTextChange.add(s),
//                  );
//                }
//              ),
//            )
          ]),
    );
  }
}

final onTextChange = BehaviorSubject.seeded('Text');

////////////////////////////////////////////////////////////////////////////////

final onGo = BehaviorSubject.seeded(false);

typedef AnimWidgetBuilder = Widget Function(BuildContext ctx, dynamic anim);

class Animator {
  static const durationPart1 = const Duration(milliseconds: 100);
  static const durationPart1a = const Duration(milliseconds: 50);
  static const durationPart1b = const Duration(milliseconds: 50);

  static const backgroundColor = 'backgroundColor';
  static const childIndex = 'childIndex';

  final tween = MultiTrackTween([
    Track(backgroundColor)
        .add(durationPart1, ColorTween(begin: Colors.green, end: Colors.white)),
    Track(childIndex)
        .add(durationPart1, ConstantTween(0))
        .add(durationPart1, ConstantTween(1)),
  ]);

  static final Animator me = Animator();
}

class AnimContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => onGo.add(!onGo.value),
      child: StreamBuilder<bool>(
        initialData: onGo.value,
        stream: onGo,
        builder: (context, snapshot) {
          final v = snapshot.data ?? false;
          return ControlledAnimation(
            playback: v ? Playback.PLAY_FORWARD : Playback.PLAY_REVERSE,
            tween: Animator.me.tween,
            duration: Animator.me.tween.duration,
            builder: (ctx, anim) {
              return buildButtons(ctx, anim);
            },
          );
        }
      ),
    );
  }

  Widget buildButtons(context, anim) {
    return Container(
      decoration: boxDecoration(anim[Animator.backgroundColor]),
      child: contentChildren[anim[Animator.childIndex]](context, anim),
    );
  }

  BoxDecoration boxDecoration(Color backgroundColor) {
    return BoxDecoration(color: backgroundColor);
  }

  final contentChildren = <AnimWidgetBuilder>[
    simpleButtons,
    masterButtons,
  ];

  static final AnimWidgetBuilder simpleButtons = (ctx, anim) => Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('button1'),
                onPressed: () => onGo.add(!onGo.value),
              ),
              RaisedButton(
                child: Text('button2'),
                onPressed: () => onGo.add(!onGo.value),
              ),
            ],
          ),
        ),
      );

  static final AnimWidgetBuilder masterButtons = (ctx, anim) => Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('button1'),
                    onPressed: () => onGo.add(!onGo.value),
                  ),
                  RaisedButton(
                    child: Text('button2'),
                    onPressed: () => onGo.add(!onGo.value),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('button3'),
                    onPressed: () => onGo.add(!onGo.value),
                  ),
                  RaisedButton(
                    child: Text('button4'),
                    onPressed: () => onGo.add(!onGo.value),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
