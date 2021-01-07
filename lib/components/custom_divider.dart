import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key key, this.vertical = false, this.widthcustom = 1.5})
      : super(key: key);
  final widthcustom;
  final vertical;

  @override
  Widget build(BuildContext context) {
    var width;
    var height;
    var begin;
    var end;
    if (vertical) {
      width = widthcustom;
      height = double.infinity;
      begin = Alignment.topCenter;
      end = Alignment.bottomCenter;
    } else {
      width = double.infinity;
      height = widthcustom;
      begin = Alignment.centerLeft;
      end = Alignment.centerRight;
    }

    return SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin,
                  end: end,
                  colors: [Colors.white, Colors.grey, Colors.white])),
        ));
  }
}
