import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/custom_divider.dart';
import 'package:flutter_app_test/components/my_button.dart';
import 'package:flutter_app_test/components/my_tab_controller.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/components/programs_page_view.dart';
import 'package:flutter_app_test/models/certificat.dart';
import 'package:flutter_app_test/models/webinar.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';

getWebinars(context, callback, pid) async {
  var result = await sendPost('getwebinars2', {"id": pid.toString()});
  if (result['error'] == false) {
    var webinars = [];
    result['answer'].forEach((arrayItem) {
      webinars.add(Webinar(
        int.parse(arrayItem["id"].toString()),
        arrayItem["title"],
        int.parse(arrayItem["pid"].toString()),
        arrayItem["start_date"],
        arrayItem["start_time"],
        int.parse(arrayItem["sub"].toString()),
        int.parse(arrayItem["start_unixtime"].toString()),
        int.parse(arrayItem["finish_time"].toString()),
      ));
    });
    if (webinars.length == 0) {
      webinars.add(Webinar(
        0,
        "Вебинары по данной программе не доступны",
        0,
        "",
        "",
        0,
        0,
        0,
      ));
    }
    callback(webinars);
  } else {
    showToast(context, text: result['answer']);
  }
}

getSertificats(context, callback, pid) async {
  var result = await sendPost('getpartisipiantwebinar', {"id": pid.toString()});
  var sertificats = [];
  if (result['error'] == false) {
    result['answer'].forEach((arrayItem) {
      sertificats.add(Sertificat(
        int.parse(arrayItem["webid"].toString()),
        int.parse(arrayItem["pid"].toString()),
        arrayItem["theme"],
        arrayItem["url"],
      ));
    });
    if (sertificats.length == 0) {
      sertificats
          .add(Sertificat(0, 0, 'Сертификатов по данной программе нет', ''));
    }
    callback(sertificats);
  } else {
    sertificats
        .add(Sertificat(0, 0, 'Сертификатов по данной программе нет', ''));
    callback(sertificats);
    // showToast(context, text: result['answer']);
  }
}

setWebinarSub(context, webid, callback) async {
  var result = await sendPost('webinarsub', {"id": webid.toString()});
  if (result['error'] == false) {
    callback(_WebinarsState._pid);
  } else {
    showToast(context, text: result['answer']);
  }
}

class Webinars extends StatefulWidget {
  @override
  _WebinarsState createState() => _WebinarsState();
}

class _WebinarsState extends State<Webinars> {
  List _webinars = [];
  List _sertificats = [];
  static bool _loading = false;
  static int _pid = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // if(TabController.of(context) != null) TabController.of(context).delete();
  }

  setPid(pid) {
    setState(() {
      _loading = true;
      _pid = pid;
      getWebinars(context, setWebinars, _pid);
      getSertificats(context, setSertificats, _pid);
    });
  }

  setWebinars(webinars) {
    setState(() {
      _webinars = webinars;
      _loading = false;
    });
  }

  setSertificats(sertificats) {
    setState(() {
      _sertificats = sertificats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(children: [
      PageHeader(header: 'Календарь вебинаров'),
      ProgramsPageView(callback: this.setPid),
      TabController(
        webinars: _webinars,
        sertificats: _sertificats,
        reloadlist: setPid,
      ),
    ]);
  }
}

class TabController extends StatefulWidget {
  const TabController(
      {Key key,
      @required List webinars,
      @required List sertificats,
      @required Function reloadlist})
      : _webinars = webinars,
        _sertificats = sertificats,
        _callback = reloadlist,
        super(key: key);
  final List _webinars;
  final List _sertificats;
  final Function _callback;

  static _TabControllerState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_TabControllerState>());

  @override
  _TabControllerState createState() => _TabControllerState();
}

class _TabControllerState extends State<TabController> {
  var _onSubscribe;
  var _onDownload;
  double _progress = 0;
  int _progresbarSize = 40;
  List<String> _headers = ['Вебинары', 'Сертификаты'];


  @override
  void initState() {
    _progress = 0;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void delete() {
    setState(() {
      return null;
    });
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress =  double.parse((_progresbarSize * received / total).toStringAsFixed(2));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> _lists = [widget._webinars, widget._sertificats];
    List<Function> _cards = [getWebinarCard, getSertificatCard];
    List<Function> _callbacks = [_onSubscribe, (){}];

    _onSubscribe = (int webid) {
      setState(() {
        setWebinarSub(context, webid, widget._callback);
      });
    };

    _onDownload = (String url) {
      downloadFile(DOMAIN + url, context, _onReceiveProgress);
    };

    return MyTabController(_headers,_WebinarsState._loading, _lists, _cards, _callbacks);
  }
}


getSertificatCard(items,index, mycallback) {
 return Card(
    child: Container(
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        title:
        Text(items[index].name),
        trailing: (items[index].url !=
            '')
            ? Container(
          // width: double.parse(_progresbarSize.toString()),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                      Icons.picture_as_pdf_sharp,
                      color: Colors.red),
                  onPressed: () => mycallback(
                      items[index]
                          .url),
                ),
                /*DecoratedBox(
                      child: SizedBox(
                        height: 3,
                        width: _progress,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: availableColor))*/
              ]),
        )
            : Text(''),
      ),
    ),
    margin: EdgeInsets.all(5),
    // shadowColor: Colors.lightBlueAccent,
    elevation: 7,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7)),
  );
}

getWebinarCard(items,index,mycallback) {
  return Card(
    child: Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(items[index].name,
            style: TextStyle(
                color: textColorNormal,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        children: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 10,
              ),
              CustomDivider(),
              if (items[index].webinarid != 0)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      15, 10, 10, 10),
                  child: Row(
                    children: [
                      Padding(
                          padding:
                          EdgeInsets.fromLTRB(
                              0, 0, 15, 0),
                          child: Text(items[index]
                              .day)),
                      SizedBox(
                        width: 2,
                        height: 30,
                        child: DecoratedBox(
                            decoration:
                            BoxDecoration(
                                color: Colors
                                    .grey)),
                      ),
                      Padding(
                          padding:
                          EdgeInsets.fromLTRB(
                              15, 0, 0, 0),
                          child: Text(items[index]
                              .time)),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 10,
                          height: 10,
                        ),
                      ),
                      MyButton(
                          text: (items[
                          index]
                              .subscribe ==
                              1)
                              ? 'Отписаться'
                              : 'Подписаться',
                          callback: () =>
                              mycallback(items[index]
                                  .webinarid),
                          color: (items[
                          index]
                              .subscribe ==
                              1)
                              ? unAvailableColor
                              : mainColor),
                    ],
                  ),
                )
              else
                Text(''),
            ],
          )
        ],
      ),
    ),
    margin: EdgeInsets.all(5),
    // shadowColor: Colors.lightBlueAccent,
    elevation: 7,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7)),
  );
}
