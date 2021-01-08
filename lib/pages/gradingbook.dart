import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/components/programs_page_view.dart';
import 'package:flutter_app_test/models/grade.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';

getGrades(context, callback, pid) async {
  var result = await sendPost('getgrades', {"id": pid.toString()});
  if (result['error'] == false) {
    var grades = [];
    if (result['answer'].length > 0) {
      var data = result['answer'][0];
      var current_list_data = data['program_grades'];
      current_list_data.forEach((arrayItem) {
        grades.add(Grade(arrayItem["course_name"], arrayItem["name"],
            int.parse(arrayItem["ball"].toString()), arrayItem["litter"]));
      });
    } else {
      grades.add(Grade('По данной программе нет оценок', '', 0, ''));
    }
    // if (grades.length == 0) {
    // }

    callback(grades);
  } else {
    showToast(context, text: result['answer']);
  }
}

class GradingBook extends StatefulWidget {
  @override
  _GradingBookState createState() => _GradingBookState();

  static _GradingBookState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_GradingBookState>());
}

class _GradingBookState extends State<GradingBook> {
  List _grades = [];
  int _pid = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  setPid(pid) {
    setState(() {
      isLoading = true;
      _pid = pid;
      getGrades(context, setGrades, _pid);
    });
  }

  setGrades(grades) {
    setState(() {
      _grades = grades;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: [
        PageHeader(header: "Зачетная книжка"),
        ProgramsPageView(callback: this.setPid),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 10),
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          height: 30,
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7), topRight: Radius.circular(7)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Дисциплина',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: secondColor)),
              Text('Балл',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: secondColor)),
            ],
          ),
        ),
        isLoading
            ? Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  backgroundColor: mainColor,
                ),
              )
            : Container(
                child: Expanded(
                  child: Container(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: _grades.length,
                      itemBuilder: (item, index) => Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _grades[index].coursename,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (_grades[index].type != '')
                                    Text(_grades[index].ball.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                ]),
                            if (_grades[index].type != '')
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_grades[index].type,
                                        style:
                                            TextStyle(color: textColorLight)),
                                    Row(
                                      children: [
                                        Text('Оценка:',
                                            style: TextStyle(
                                                color: textColorLight)),
                                        Text(_grades[index].litter,
                                            style: TextStyle(
                                                color: textColorDark)),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                          ]),
                        ),
                        margin: EdgeInsets.all(5),
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                      ),
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
