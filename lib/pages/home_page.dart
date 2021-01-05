import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/fragments/library_item.dart';
import 'package:flutter_app_test/pages/autorization.dart';
import 'package:flutter_app_test/pages/course.dart';
import 'package:flutter_app_test/pages/gradingbook.dart';
import 'package:flutter_app_test/pages/syllabus.dart';
import 'package:flutter_app_test/pages/library.dart';
import 'package:flutter_app_test/pages/webinars.dart';
import 'package:flutter_app_test/pages/webview.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    DrawerItem("Учебный план", Icons.school),
    DrawerItem("Электронная библиотека", Icons.library_books),
    DrawerItem("Календарь вебинаров", Icons.calendar_today),
    DrawerItem("Зачетная книжка", Icons.grading),
  ];

  static _HomePageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_HomePageState>());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  int _selectedDrawerIndex = 0;
  int _selectedBotomIndex = 0;
  int _previousBottomIndex = 0;
  ScrollController _scrollBottomBarController = new ScrollController();
  bool _show = false;
  bool _bottom_menu_clicked = false;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
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
    if (token != '0') {
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

  void hideBars() {
    setState(() {
      _show = false;
    });
  }

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  setToken(tok) {
    setState(() => {token = tok});
    showBars();
  }

  _getDrawerItemWidget(int pos) {
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
    if (token != '0') {
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
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon, color: mainColor),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
        key: _scaffoldKey,
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
                title: Image.asset(
                  'assets/images/logoheader.png',
                  width: 150,
                  height: 60,
                ),
              )
            : PreferredSize(child: Container(), preferredSize: Size(0.0, 0.0)),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text("John Doe"), accountEmail: null),
              Column(children: drawerOptions)
            ],
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            _onPopUp();
          },
          child: Navigator(
            key: navigationMain,
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              WidgetBuilder builder;
              // Manage your route names here
              switch (settings.name) {
                case '/':
                  builder = (BuildContext context) =>
                      _getDrawerItemWidget(_selectedDrawerIndex);
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
              if (settings.name != '/') updateWidget();
              return MaterialPageRoute(
                builder: builder,
                settings: settings,
              );
            },
          ),
        ),
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
                      icon: Icon(Icons.school),
                      label: 'Курсы',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.my_library_books),
                      label: 'Библиотека',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.message),
                      label: 'Сообщения',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu),
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
