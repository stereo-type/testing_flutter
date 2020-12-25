import 'package:flutter/material.dart';
import 'package:flutter_app_test/fragments/autorization.dart';
import 'package:flutter_app_test/fragments/syllabus.dart';
import 'package:flutter_app_test/fragments/second_fragment.dart';
import 'package:flutter_app_test/fragments/third_fragment.dart';
import 'package:flutter_app_test/utils/settings.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    DrawerItem("Учебный план", Icons.school),
    DrawerItem("Календарь вебинаров", Icons.calendar_today),
    DrawerItem("Зачетная книжка", Icons.grading),
    DrawerItem("Электронная библиотека", Icons.library_books),
  ];

  // @override
  // State<StatefulWidget> createState() {
  //   return  _HomePageState();
  // }

  static _HomePageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_HomePageState>());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String _token = '0';
  int _selectedDrawerIndex = 0;
  int _selectedBotomIndex = 0;
  ScrollController _scrollBottomBarController = new ScrollController();
  bool _show = false;

  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedBotomIndex = index;
    });
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
    if (token != '0') {
      switch (pos) {
        case 0:
          return Syllabus();
        case 1:
          return SecondFragment();
        case 2:
          return ThirdFragment();

        default:
          return Text("Error");
      }
    } else {
      hideBars();
      return Autorization();
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
        appBar: _show
            ? AppBar(
                // here we display the title corresponding to the fragment
                // you can instead choose to have a static title
                title: Text(widget.drawerItems[_selectedDrawerIndex].title),
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
        body: _getDrawerItemWidget(_selectedDrawerIndex),
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
