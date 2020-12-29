import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/settings.dart';

class MyButton extends StatefulWidget {
  const MyButton({Key key, @required String text, @required Function callback, color = mainColor})
      : _text = text,
        _callback = callback,
        _color = color,
        super(key: key);
  final String _text;
  final Function _callback;
  final _color;

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      minWidth: 110,
      color: widget._color,
      textColor: secondColor,
      disabledColor: unAvailableColor,
      disabledTextColor: secondColor,
      padding: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      splashColor: Colors.blueAccent,
      onPressed: widget._callback,
      child: Text(
        widget._text,
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }
}
