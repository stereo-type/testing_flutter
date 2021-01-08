import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/components/custom_divider.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';

import '../custom_icons.dart';

class AutorizationBottomBar extends StatelessWidget {
  const AutorizationBottomBar({
    Key key, this.colors = const [unAvailableColor, unAvailableColor, unAvailableColor]
  }) : super(key: key);
  final colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            color: colors[0],
            hoverColor: mainColor,
            focusColor: mainColor,
            icon: Icon(CustomIcons.go_to_cite, size: 28),
            onPressed: () {
              navigationMain.currentState
                  .pushNamed('/webview', arguments: {"url": DOMAIN});
            },
          ),
          CustomDivider(vertical: true),
          IconButton(
            color: colors[1],
            hoverColor: mainColor,
            focusColor: mainColor,
            icon: Icon(CustomIcons.mobile, size: 28),
            onPressed: () {
              final newRouteName = "/ask_call";
              Navigator.of(context).pushNamedWithoutHistoryIfNotCurrent(newRouteName);
            },
          ),
          CustomDivider(vertical: true),
          IconButton(
            color: colors[2],
            hoverColor: mainColor,
            focusColor: mainColor,
            icon: Icon(CustomIcons.question, size: 28),
            onPressed: () {
              final newRouteName = "/ask_question";
              Navigator.of(context).pushNamedWithoutHistoryIfNotCurrent(newRouteName);
            },
          ),
        ],
      ),
    );
  }
}
