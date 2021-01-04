import 'package:flutter_app_test/fragments/library_item.dart';
import 'package:flutter_app_test/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';

import 'pages/gradingbook.dart';
import 'pages/library.dart';
import 'pages/webinars.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: mainColor,
        accentColor: secondColor,
        dividerColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color:  textColorNormal),
          headline2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColorNormal),
          headline3: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: textColorNormal),
          headline4: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: textColorNormal),
          headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: textColorNormal),
          headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: textColorNormal),
          bodyText1: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: textColorNormal),
          bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: textColorNormal),
        ),
      ),
      home: HomePage(),
      // navigatorKey: navigationService.navigatorKey,
      /*routes: {
        '/': (context)=> HomePage(),
      },*/
    );
  }
}






