import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/my_button.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/components/programs_page_view.dart';
import 'package:flutter_app_test/components/custom_divider.dart';
import 'package:flutter_app_test/models/course.dart';
import 'package:flutter_app_test/utils/common.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';

class Syllabus extends StatefulWidget {
  Syllabus({Key key}) : super(key: key);

  static _SyllabusState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_SyllabusState>());

  @override
  _SyllabusState createState() => _SyllabusState();
}

class _SyllabusState extends State<Syllabus> {
  List _courses = [];
  int _pid = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  setPid(pid) {
    setState(() {
      _loading = true;
      _pid = pid;
      getCourses(context, setCourses, _pid);
    });
  }

  setCourses(courses) {
    setState(() {
      _courses = courses;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        page_header(header: 'Программы', paddings: [10, 10, 10, 0]),
        programs_page_view(callback: this.setPid),
        page_header(header: 'Курсы', paddings: [10, 0, 10, 10]),
        (_loading)
            ? CircularProgressIndicator(
                backgroundColor: mainColor,
              )
            : Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemCount: _courses.length,
                  itemBuilder: (course, index) => Card(
                    child: Container(
                      padding: EdgeInsets.only(left: 7.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: _courses[index].available
                            ? availableColor
                            : unAvailableColor,
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(7.0),
                                bottomRight: Radius.circular(7.0)),
                            color: Colors.white,
                          ),
                          child: Container(
                            child: ExpansionTile(
                                maintainState: true,
                                initiallyExpanded: false,
                                tilePadding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                title: Text(_courses[index].name,
                                    style: TextStyle(
                                        color: textColorNormal,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                childrenPadding:
                                    EdgeInsets.fromLTRB(10, 0, 10, 10),
                                children: [
                                  Column(
                                    children: [
                                      CustomDivider(),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 10,
                                      ),
                                      Text('Условия доступа:'),
                                      Row(
                                        children: [
                                          if (_courses[index].teacherpicture !=
                                              '')
                                            ClipOval(
                                              child: Image.network(
                                                domen +
                                                    _courses[index]
                                                        .teacherpicture,
                                                loadingBuilder:
                                                    (context, child, progress) {
                                                  if (progress == null)
                                                    return child;
                                                  return CircularProgressIndicator(
                                                    value: progress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? progress
                                                                .cumulativeBytesLoaded /
                                                            progress
                                                                .expectedTotalBytes
                                                        : null,
                                                  );
                                                },
                                                width: 40,
                                                height: 40,
                                              ),
                                            ),
                                          if (_courses[index]
                                                  .teacherfirstname !=
                                              '')
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 0, 0, 0),
                                              child: Text(
                                                _courses[index]
                                                        .teacherlastname +
                                                    " " +
                                                    getInitials(_courses[index]
                                                        .teacherfirstname),
                                              ),
                                            )
                                          else
                                            Text(""),
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              width: 10,
                                              height: 10,
                                            ),
                                          ),
                                          MyButton(
                                              text: 'Войти',
                                              callback: _courses[index]
                                                      .available
                                                  ? () {
                                                      navigationMain
                                                          .currentState
                                                          .pushNamed('/course',
                                                              arguments: {
                                                            "course":
                                                                _courses[index],
                                                            "pid": _pid
                                                          });
                                                    }
                                                  : null)
                                          /*RaisedButton(
                                      color: mainColor,
                                      padding: EdgeInsets.all(10),
                                      textColor: secondColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      onPressed:_courses[index].available ? () {
                                        navigationMain.currentState
                                          .pushNamed('/course', arguments: {"course": _courses[index]});} : null,
                                      child: Text('Войти',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                    ),*/
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                          )),
                    ),
                    margin: EdgeInsets.all(5),
                    // shadowColor: Colors.lightBlueAccent,
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )
      ],
    );
  }
}
