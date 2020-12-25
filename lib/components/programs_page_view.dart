import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/models/program.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';


getPrograms(context, callback) async {
  var result = await sendPost('getprograms', {});
  if (result['error'] == false) {
    var progs = [];
    result['answer'].forEach((arrayItem) {
      progs.add(Programm(int.parse(arrayItem["id"]), arrayItem["name"],
          int.parse(arrayItem["isfacult"])));
    });
    callback(progs);
  } else {
    showToast(context, text: result['answer']);
  }
}

class programs_page_view extends StatefulWidget {
  const programs_page_view({
    Key key,
  }) : super(key: key);

  @override
  _programs_page_viewState createState() => _programs_page_viewState();
}

class _programs_page_viewState extends State<programs_page_view> {
  List _programs = [];

  @override
  void initState() {
    getPrograms(context, setProgramms);
    super.initState();
  }

  setProgramms(programs) {
    setState(() {
      _programs = programs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
          children: _programs
              .map((program) => Container(
                    child: Row(
                      children: [
                        Icon(Icons.school),
                        Text(program.name),
                      ],
                    ),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15)),
                  ))
              .toList()),
      height: 100,
    );
  }
}
