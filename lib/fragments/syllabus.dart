import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/programs_page_view.dart';
import 'package:flutter_app_test/models/course.dart';
import 'package:flutter_app_test/utils/utils.dart';

getCourses(context, callback, pid) async {
  var result = await sendPost('eduplan', {"id": pid.toString()});
  if (result['error'] == false) {
    var courses = [];
    result['answer'].forEach((arrayItem) {
      courses.add(Course((arrayItem["id"]), arrayItem["name"],
          (arrayItem["isifer"])));
    });
    callback(courses);
  } else {
    showToast(context, text: result['answer']);
  }
}



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

  setPid(pid) {
    setState(() {
      _pid = pid;
      getCourses(context, setCourses, _pid);
    });
  }

  @override
  void initState() {
    // getCourses(context, setCourses, _pid);
    super.initState();
  }

  setCourses(courses) {
    setState(() {
      _courses = courses;
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child:
                Text("Программы", style: Theme.of(context).textTheme.headline2),
          ),
        ),
        programs_page_view(),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text("Курсы", style: Theme.of(context).textTheme.headline2),
          ),
        ),
        Expanded(
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: _courses.length,
              itemBuilder: (course, index) => Text(_courses[index].name)),
        )
      ],
    );
  }
}
