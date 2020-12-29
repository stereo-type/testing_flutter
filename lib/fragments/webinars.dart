import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/programs_page_view.dart';
import 'package:flutter_app_test/models/webinar.dart';
import 'package:flutter_app_test/utils/utils.dart';

getWebinars(context, callback, pid) async {
  var result = await sendPost('getwebinars2', {"id": pid.toString()});
  if (result['error'] == false) {
    var webinars = [];
    result['answer'].forEach((arrayItem) {
      print(arrayItem);
      webinars.add(Webinar(
        int.parse(arrayItem["id"]),
        arrayItem["title"],
        int.parse(arrayItem["pid"]),
        arrayItem["start_date"],
        arrayItem["start_time"],
        int.parse(arrayItem["sub"]),
        int.parse(arrayItem["start_unixtime"]),
        int.parse(arrayItem["finish_time"]),
      ));
    });
    callback(webinars);
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
  int _pid = 0;

  setPid(pid) {
    setState(() {
      _pid = pid;
      getWebinars(context, setWebinars, _pid);
    });
  }

  setWebinars(webinars) {
    setState(() {
      _webinars = webinars;
      print(_webinars);
    });
  }

  setSertificats(sertificats) {
    setState(() {
      _webinars = sertificats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: programs_page_view(callback: this.setPid),
    );
  }
}
