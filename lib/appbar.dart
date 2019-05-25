import 'package:f_latte/service_locator.dart';
import 'package:f_latte/text_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'generated/i18n.dart';

class AppBarWidget extends StatelessWidget {

  final _mgr = sl<TextManager>();

  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _mgr.txtCmd,
      builder: (context, snapshot) {

        final txt = snapshot?.data != null ? snapshot?.data : '';

        if(txt != ''){
          _ctrl.text = '${txt} (${txt.length})';
        }else{
          _ctrl.text = S.of(context).emptyField;
        }

        return Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _ctrl,
                style: TextStyle(
                  color: txt.isEmpty ? Colors.red : Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: txt.isEmpty ? Colors.white : Colors.red,
                ),
                onPressed: null
            ),
          ],
        );
      },
    );
  }
}
