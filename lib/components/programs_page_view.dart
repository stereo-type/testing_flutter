import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/models/program.dart';
import 'package:flutter_app_test/utils/settings.dart';
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
    Key key,  @required Function callback
  }) : _callback = callback,
        super(key: key);
  final Function _callback;

  @override
  _programs_page_viewState createState() => _programs_page_viewState(_callback);
}

class _programs_page_viewState extends State<programs_page_view> {
  _programs_page_viewState(Function callback) : _callback = callback;
  final Function _callback;

  List _programs = [];
  int _pid = 0;
  int _position = 0;

  @override
  void initState() {
    getPrograms(context, setProgramms);
    super.initState();
  }

  setProgramms(programs) {
    setState(() {
      _programs = programs;
      _callback(_programs[_position].pid);
    });
  }

  setCurrentPid(itemid) {
    setState(() {
      _position = itemid;
      _pid = _programs[itemid].pid;
      _callback(_programs[_position].pid);
    });
  }

  @override
  Widget build(BuildContext context) {
    // double c_width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      child: Column(children: [
        Container(
          child: PageView.builder(
            onPageChanged: setCurrentPid,
            itemCount: _programs.length,
            itemBuilder: (context, position) {
              return ProgramItem(programs: _programs, position: position);
            },
          ),
          height: 115,
        ),
        Text((_position + 1).toString() + '/' + _programs.length.toString())
      ]),
    );
  }
}

class ProgramItem extends StatelessWidget {
  const ProgramItem({Key key, @required List programs, @required int position})
      : _programs = programs,
        _position = position,
        super(key: key);
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
            child: Text(_programs[_position].name, style: TextStyle(color: secondColor,
                fontWeight: FontWeight.w500, fontSize: 14), maxLines: 4, overflow: TextOverflow.ellipsis,),
          ),
        ],
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(7)),
    );
  }
}
