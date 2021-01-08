import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/fragments/ask_call.dart';
import 'package:flutter_app_test/fragments/ask_question.dart';
import 'package:flutter_app_test/fragments/forgot_password.dart';
import 'package:flutter_app_test/fragments/library_item.dart';
import 'package:flutter_app_test/fragments/user_info_edit.dart';
import 'package:flutter_app_test/pages/course.dart';
import 'package:flutter_app_test/pages/home_page.dart';
import 'package:flutter_app_test/pages/user_info.dart';
import 'package:flutter_app_test/pages/webview.dart';
import 'package:flutter_app_test/utils/settings.dart';

class Navigation extends StatefulWidget {
  const Navigation(
    this.mainBuilder,
    this.index,
    this.callback, {
    Key key,
  }) : super(key: key);
  final mainBuilder;
  final index;
  final callback;

  static _NavigationState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_NavigationState>());

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigationMain,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        // Manage your route names here
        switch (settings.name) {
          case '/':
            // if (settings.arguments != null) {
            //   if ((settings.arguments as Map)['hideBars'] != null &&
            //       (settings.arguments as Map)['hideBars'] == true) {
            //     if (HomePage.of(context) != null) {
            //       HomePage.of(context).hideBars();
            //       Navigator.of(context).pop();
            //     }
            //   }
            // }

            builder =
                (BuildContext context) => widget.mainBuilder(widget.index);
            break;
          case '/ask_call':
            builder = (BuildContext context) => AskCall();
            break;
          case '/ask_question':
            builder = (BuildContext context) => AskQuestion();
            break;
          case '/forgot_password':
            builder = (BuildContext context) => ForgotPassword();
            break;
          case '/user_info':
            builder = (BuildContext context) => UserInfoPage();
            break;
          case '/user_info_edit':
            builder = (BuildContext context) => UserInfoEdit();
            break;
          case '/libraryitem':
            builder = (BuildContext context) => LibraryItem();
            break;
          case '/course':
            builder = (BuildContext context) => CoursePage();
            break;
          case '/webview':
            builder = (BuildContext context) => WebViewPage();
            break;
          case '/mvideo':
            builder = (BuildContext context) => LibraryItem(isLibrary: false);
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        // You can also return a PageRouteBuilder and
        // define custom transitions between pages
        if (settings.name != '/') widget.callback();
        return MaterialPageRoute(
          builder: builder,
          settings: settings,
        );
      },
    );
  }
}
