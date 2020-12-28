import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/models/program.dart';
import 'package:flutter_app_test/utils/utils.dart';
import 'package:flutter_app_test/fragments/syllabus.dart';

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
  int _pid = 0;

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

  setCurrentPid(itemid) {
    setState(() {
      _pid =  _programs[itemid].pid;
      Syllabus.of(context).setPid(_pid);
    });
  }

  @override
  Widget build(BuildContext context) {
    // double c_width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      child: PageView.builder(
        onPageChanged: setCurrentPid,
        itemCount: _programs.length,
        itemBuilder: (context, position) {
          return ProgramItem(programs: _programs, position: position);
        },
      ),
      height: 110,
    );
  }
}

class ProgramItem extends StatelessWidget {
  const ProgramItem({
    Key key,
    @required List programs,
    @required int position
  }) : _programs = programs, _position = position, super(key: key);
  final int _position;
  final List _programs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Icon(
                Icons.school,
                color: Theme.of(context).accentColor,
                size: 24,
              )),
          Expanded(
            child: Text(_programs[_position].name,
                style: Theme.of(context).textTheme.headline4),
          ),
        ],
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15)),
    );
  }
}
