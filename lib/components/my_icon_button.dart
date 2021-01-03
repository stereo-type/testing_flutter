import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/settings.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({
    Key key,  @required Icon icon, @required callback,
  }) :  _icon = icon, _callback = callback,
        super(key: key);
  final Icon _icon;
  final _callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      child: IconButton(
          padding: EdgeInsets.all(0),
          iconSize: 18,
          icon: _icon,
          onPressed: _callback),
    );
  }
}