import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/my_drawer.dart';
import 'package:flutter_app_test/components/user_logo.dart';
import 'package:flutter_app_test/dbhelper/db.dart';
import 'package:flutter_app_test/fragments/ask_call.dart';
import 'package:flutter_app_test/fragments/ask_question.dart';
import 'package:flutter_app_test/fragments/forgot_password.dart';
import 'package:flutter_app_test/fragments/library_item.dart';
import 'package:flutter_app_test/models/user.dart';
import 'package:flutter_app_test/pages/autorization.dart';
import 'package:flutter_app_test/pages/course.dart';
import 'package:flutter_app_test/pages/gradingbook.dart';
import 'package:flutter_app_test/pages/syllabus.dart';
import 'package:flutter_app_test/pages/library.dart';
import 'package:flutter_app_test/pages/webinars.dart';
import 'package:flutter_app_test/pages/webview.dart';
import 'package:flutter_app_test/utils/common.dart';
import 'package:flutter_app_test/utils/navigation.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_app_test/custom_icons.dart';

class HomePage extends StatefulWidget {
  static _HomePageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_HomePageState>());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  ScrollController _scrollBottomBarController = new ScrollController();
  final db = DatabaseHelper.instance;
  Map<String, dynamic> _user;

  int _selectedDrawerIndex = 0;
  int _selectedBotomIndex = 0;
  int _previousBottomIndex = 0;
  bool _show = false;
  bool _bottom_menu_clicked = false;

  checkToken() async {
    //todo temp
    // await db.delete_datebase();

    var count = await db.get_count('token');
    var records = await db.get_records('token');
    if (count == 1) {
      var token = records[0]["token"];
      setToken(token);
    }
  }

  setUser() async {
    _user = (await db.get_records('user'))[0];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    checkToken();
    /* final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);*/
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedBotomIndex = index;
      _bottom_menu_clicked = true;
    });
  }

  void updateWidget() {
    setState(() {});
  }

  _getPagesForBottomNav(int index) {
    if (TOKEN != '0') {
      if (index != 3) {
        // setState(() {
        _previousBottomIndex = index;
        // });
      }
      switch (index) {
        case 0:
          return Syllabus();
          break;
        case 1:
          return Library();
          break;
        case 2:
          return GradingBook();
          break;
        case 3:
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scaffoldKey.currentState.openDrawer();
          });

          return _getPagesForBottomNav(_previousBottomIndex);
          break;
        default:
          return Text("Error");
      }
    } else {
      // hideBars();
      return Autorization();
    }
  }

  void showBars() {
    setState(() {
      _show = true;
    });
  }

  void closeDrawer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState.openEndDrawer();
    });
  }

  void hideBars() {
    setState(() {
      _show = false;
      closeDrawer();
    });
  }

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  setToken(String newtoken) async {
    setState(() => {TOKEN = newtoken});
    await getUserinfo(context, db);
    USER = (await db.get_records('user'))[0];
    showBars();
  }

  getDrawerItemWidget(int pos) {
    // return ExempleDownload(title: 'Flutter Demo Home Page');
/*    if (_bottom_menu_clicked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
        _bottom_menu_clicked = false;
        });
      });
      return _getPagesForBottomNav(_selectedBotomIndex);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _bottom_menu_clicked = false;
        });
      });*/
    if (TOKEN != '0') {
      switch (pos) {
        case 0:
          return Syllabus();
        case 1:
          return Library();
        case 2:
          return Webinars();
        case 3:
          return GradingBook();

        default:
          return Text("Error");
      }
    } else {
      // hideBars();
      return Autorization();
      // }
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    if (Navigation.of(context) != null) {
      Navigation.of(context).update();
    }
    Navigator.of(context).pop(); // close the drawer
  }

  _onPopUp() {
    if (navigationMain.currentState.canPop()) {
      updateWidget();
      navigationMain.currentState.pop('/');
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: _show
            ? AppBar(
                leading: Builder(
                  builder: (context) => (!navigationMain.currentState.canPop())
                      ? IconButton(
                          icon: Icon(Icons.menu_rounded),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        )
                      : IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: _onPopUp,
                        ),
                ),
                backgroundColor: secondColor,
                iconTheme: IconThemeData(color: textColorNormal),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/logoheader.png',
                        width: 150,
                        height: 60,
                      ),
                      userLogo(USER),
                    ]),
              )
            : PreferredSize(child: Container(), preferredSize: Size(0.0, 0.0)),
        drawer: MyDrawer(callback: _onSelectItem, index: _selectedDrawerIndex),
        body: WillPopScope(
            onWillPop: () {
              _onPopUp();
            },
            child: Navigation(
                getDrawerItemWidget, _selectedDrawerIndex, updateWidget)),
        bottomNavigationBar: _show
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(CustomIcons.user_study),
                      label: 'Курсы',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CustomIcons.library_icon),
                      label: 'Библиотека',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CustomIcons.comments_solid),
                      label: 'Сообщения',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CustomIcons.ellipsis_h_solid),
                      label: 'Меню',
                    ),
                  ],
                  currentIndex: _selectedBotomIndex,
                  selectedItemColor: Theme.of(context).primaryColor,
                  onTap: _onBottomItemTapped,
                ),
              )
            : Text(""));
  }
}


