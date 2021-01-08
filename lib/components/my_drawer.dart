import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/components/user_logo.dart';
import 'package:flutter_app_test/custom_icons.dart';
import 'package:flutter_app_test/utils/common.dart';
import 'package:flutter_app_test/utils/settings.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}


class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key key, @required this.callback, @required this.index,
  }) : super(key: key);
  final Function callback;
  final index;

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final drawerItems = [
    DrawerItem("Учебный план", CustomIcons.study),
    DrawerItem("Электронная библиотека", CustomIcons.library_icon),
    DrawerItem("Календарь вебинаров", CustomIcons.calendar),
    DrawerItem("Зачетная книжка", Icons.grading),
  ];

  var drawerOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    setDrawer();
  }

  setDrawer() {
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon, color: mainColor),
        title: Text(d.title),
        selected: i == widget.index,
        onTap: () => widget.callback(i),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: userLogo(USER, size: 50),
            otherAccountsPictures: [
              GestureDetector(
                  onTap: logOut,
                  child: Text('Выйти',
                      style: TextStyle(
                          color: secondColor,
                          decoration: TextDecoration.underline)))
            ],
            accountName: (USER != null)
                ? Text(USER['lastname'] + ' ' + USER['firstname'])
                : Text(''),
            accountEmail: (USER != null) ? Text(USER['email']) : Text(''),
          ),
          Column(children: drawerOptions)
        ],
      ),
    );
  }
}