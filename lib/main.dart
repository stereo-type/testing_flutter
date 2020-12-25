import 'package:flutter_app_test/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/settings.dart';

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
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color:  Colors.grey),
          headline2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColorNormal),
          headline3: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green),
          headline4: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: secondColor),
          headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green),
          headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green),
          bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: textColorNormal),
          bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: textColorNormal),
        ),
      ),
      home: HomePage(),
    );
  }
}






