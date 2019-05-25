import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: TextField(

            ),
        ),
        IconButton(
            icon: Icon(Icons.search),
            onPressed: null
        ),
      ],
    );
  }
}
