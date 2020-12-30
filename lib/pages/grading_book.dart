import 'package:flutter/material.dart';
import 'package:flutter_app_test/models/grade.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';
import 'package:flutter_app_test/models/lib_webinar.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/components/programs_page_view.dart';

// import 'package:flutter_app_test/components/custom_divider.dart';
// import 'package:flutter_app_test/models/webinar.dart';
// import 'package:flutter_app_test/utils/settings.dart';

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
}

class _GradingBookState extends State<GradingBook> {
  List _grades = [];
  int _pid = 0;

  @override
  void initState() {
    super.initState();
  }

  setPid(pid) {
    setState(() {
      _pid = pid;
      getGrades(context, setGrades, _pid);
    });
  }

  setGrades(grades) {
    setState(() {
      _grades = grades;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: [
        page_header(header: "Зачетная книжка"),
        programs_page_view(callback: this.setPid),
        Expanded(
          child: Container(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: _grades.length,
              itemBuilder: (item, index) => Card(
                child: Container(
                  height: 90,
                  child: Row(children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: Text(
                          _grades[index].coursename,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
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
      ],
    );
  }
}
