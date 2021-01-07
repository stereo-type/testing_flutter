import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/settings.dart';

class MyDropDown extends StatelessWidget {
  const MyDropDown(this.initValue, this.value, this.callback, this.list, {Key key, FocusNode this.focusNode = null})
      : super(key: key);
  final String value;
  final String initValue;
  final Function callback;
  final FocusNode focusNode;
  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(0),
      decoration: kDefaultRoundedBorderDecoration,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            focusNode: focusNode,
            value: value,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            onChanged: (String newValue) {
              callback(newValue);
            },
            items:
            (<String>[initValue] + list).map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: textColorLighter),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
