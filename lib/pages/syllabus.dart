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
        PageHeader(header: 'Программы', paddings: [10, 10, 10, 0]),
        ProgramsPageView(callback: this.setPid),
        PageHeader(header: 'Курсы', paddings: [10, 0, 10, 10]),
        (_loading)
            ? CircularProgressIndicator(
                backgroundColor: mainColor,
              )
            : CourseList(courses: _courses, pid: _pid),
      ],
    );
  }
}

class CourseList extends StatelessWidget {
  const CourseList({
    Key key,
    @required List courses,
    @required int pid,
  })  : _courses = courses,
        _pid = pid,
        super(key: key);

  final List _courses;
  final int _pid;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          itemCount: _courses.length,
          itemBuilder: (course, index) =>
              CourseItem(courses: _courses, pid: _pid, index: index),
        ),
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  const CourseItem({
    Key key,
    @required List courses,
    @required int pid,
    @required int index,
  })  : _courses = courses,
        _pid = pid,
        _index = index,
        super(key: key);

  final List _courses;
  final int _pid;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 7.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: _courses[_index].available ? availableColor : unAvailableColor,
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
                  title: Text(_courses[_index].name,
                      style: TextStyle(
                          color: textColorNormal,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  childrenPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDivider(),
                        SizedBox(
                          width: double.infinity,
                          height: 10,
                        ),
                        _courses[_index].available
                            ? Text("")
                            : Container(
                                margin: EdgeInsets.only(top: 5, bottom: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: alarmBackgroundColor,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  'У вас нет доступа к дисциплине. '
                                  'Для доступа необходимо выполнение условий',
                                  style: TextStyle(color: alarmTextColor),
                                ),
                              ),
                        Text('Условия доступа:'),
                        if (_courses[_index].iffer != null &&
                            _courses[_index].iffer.length > 0)
                          Container(
                            // height: double.parse(
                            //     (_courses[index].iffer.length *
                            //             20)
                            //         .toString()),
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _courses[_index].iffer.length,
                                itemBuilder: (item, ifferIndex) => Padding(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 0),
                                      child: Row(children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: _courses[_index]
                                                  .iffer[ifferIndex]["access"]
                                              ? Icon(Icons.check,
                                                  color: availableColor)
                                              : Icon(Icons.close,
                                                  color: alarmColor),
                                        ),
                                        Expanded(
                                          child: Text(_courses[_index]
                                              .iffer[ifferIndex]["name"]),
                                        ),
                                      ]),
                                    )),
                          ),
                        Row(
                          children: [
                            if (_courses[_index].teacherpicture != '')
                              ClipOval(
                                child: Image.network(
                                  DOMAIN + _courses[_index].teacherpicture,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes
                                          : null,
                                    );
                                  },
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            if (_courses[_index].teacherfirstname != '')
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Text(
                                  _courses[_index].teacherlastname +
                                      " " +
                                      getInitials(
                                          _courses[_index].teacherfirstname),
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
                                callback: _courses[_index].available
                                    ? () {
                                        navigationMain.currentState
                                            .pushNamed('/course', arguments: {
                                          "course": _courses[_index],
                                          "pid": _pid
                                        });
                                      }
                                    : null)
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
