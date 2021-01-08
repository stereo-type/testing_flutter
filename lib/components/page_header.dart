import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  PageHeader(
      {Key key, @required String header, List paddings = const [10, 10, 10, 0]})
      : _header = header,
        _paddings = paddings,
        super(key: key);
  final String _header;
  final List _paddings;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            double.parse(_paddings[0].toString()),
            double.parse(_paddings[1].toString()),
            double.parse(_paddings[2].toString()),
            double.parse(_paddings[3].toString())),
        child: Text(_header, style: Theme.of(context).textTheme.headline2),
      ),
    );
  }
}
