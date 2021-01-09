import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/my_button.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/components/programs_page_view.dart';
import 'package:flutter_app_test/components/my_tab_controller.dart';
import 'package:flutter_app_test/models/user_info.dart';
import 'package:flutter_app_test/utils/common.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';
import 'package:flutter_html/flutter_html.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  int _pid;
  bool _loading = false;
  var _data;
  var _infos = [];
  var _pays = [];
  List<String> _headers = ['Информация', 'Платежи'];

  goToFormUser() {
    navigationMain.currentState.pushNamed('/user_info_edit');
  }

  setPid(pid) {
    setState(() {
      _loading = true;
      _pid = pid;
      getData(context, setData, _pid);
    });
  }

  setData(data, [bool error = false]) {
    setState(() {
      if (!error)
        _data = data;
      else
        _data = null;

      if (_data != null) {
        setPaysAndInfos(_data);
      }
      _loading = false;
    });
  }

  setPaysAndInfos(UserInfo data) {
    var programdata = (data.programdata[0]
        as Map<String, dynamic>)[_pid.toString()][0] as Map<String, dynamic>;
    setState(() {
      // _infos = programdata['infoblocks'];
      _infos = programdata['infoblocks'] +
          programdata['libonline'] +
          programdata['docs'];
      _pays = programdata['payblocks'];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> _lists = [_infos, _pays];
    List<Function> _cards = [getInfoCard, getPayCard];
    List<Function> _callbacks = [() {}, () {}];

    return Column(
      children: [
        PageHeader(header: 'Мои данные'),
        Padding(
          padding: EdgeInsets.only(top: 15, bottom: 10),
          child: Container(
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: goToFormUser,
              child: Text(
                'О Пользователе',
                style: TextStyle(color: mainColor),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        ProgramsPageView(callback: setPid),
        MyTabController(_headers, _loading, _lists, _cards, _callbacks),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
          child: MyButton(
              padding: 12.0,
              width: double.infinity,
              text: "Выйти",
              callback: logOut),
        ),
      ],
    );
  }
}

getInfoCard(items, index, mycallback) {
  return GestureDetector(
    onTap: () {
      if (items[index]['url'] != null) {
        navigationMain.currentState
            .pushNamed('/webview', arguments: {'url': items[index]['url']});
      }
    },
    child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Text(items[index]['block-title'],
                  style: TextStyle(
                      color: (items[index]['url'] == null)
                          ? textColorNormal
                          : mainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding: EdgeInsets.only(left: 7, bottom: 10),
                child: Html(data: items[index]['block-content']))
          ],
        ),
        margin: EdgeInsets.all(5),
        // shadowColor: Colors.lightBlueAccent,
        elevation: 7,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
  );
}

getPayCard(items, index, mycallback) {
  return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, top: 15),
            child: Text(items[index]['date'],
                style: TextStyle(
                    color: textColorNormal,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 15, bottom: 10),
            child: Row(
              children: [
                Text(items[index]['sum']),
                (int.parse(items[0]['ispay'].toString()) == 1)
                    ? Text(
                        ' (Оплачено)',
                        style: TextStyle(color: availableColor),
                      )
                    : Text(
                        ' (Не оплачено)',
                        style: TextStyle(color: alarmColor),
                      ),
              ],
            ),
          )
        ],
      ),
      margin: EdgeInsets.all(5),
      // shadowColor: Colors.lightBlueAccent,
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)));
}
