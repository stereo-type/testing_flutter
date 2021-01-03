import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/components/sections_page_view.dart';
import 'package:flutter_app_test/models/course.dart';
import 'package:flutter_app_test/models/modules.dart';
import 'package:flutter_app_test/models/sections.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';
import 'package:flutter_app_test/utils/common.dart';
import 'package:webview_flutter/webview_flutter.dart';

getModules(context, callback, courseid) async {
  var result = await sendPost('getcourse', {'id': courseid.toString()});
  if (result['error'] == false) {
    var modules = [];
    var modArray = result['answer'][0]['modules'];
    modArray.forEach((arrayItem) {
      modules.add(Module(
        int.parse(arrayItem["section_id"].toString()),
        (arrayItem["section_name"] != null) ? arrayItem["section_name"] : '',
        int.parse(arrayItem["module_id"].toString()),
        arrayItem["module_name"],
        arrayItem["module_url"],
        arrayItem["module_type"],
        arrayItem["module_icon"],
      ));
    });
    callback(modules);
  } else {
    showToast(context, text: result['answer']);
  }
}

class CoursePage extends StatefulWidget {
  CoursePage({Key key}) : super(key: key);

  static _CoursePageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_CoursePageState>());

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  List _courses = [];
  List _modules = [];
  List _current_modules = [];

  // List _sections = [Section(1, 'Test')];
  List _sections = [];
  int _courseid = 0;
  int _pid = 0;
  int _sectionid = 0;

  @override
  void initState() {
    super.initState();
  }

  setPid(pid) {
    setState(() {
      _pid = pid;
      getCourses(context, setCourses, _pid, _courseid);
    });
  }

  setCourses(courses) {
    setState(() {
      _courses = courses;
    });
  }

  setCourseId(courseid) {
    setState(() {
      _courseid = courseid;
      getModules(context, setModules, _courseid);
    });
  }

  setModules(modules) {
    setState(() {
      _modules = modules;
      _sections = getSectionsFromModuleList(_modules);
    });
  }

  setSectionid(sectionid) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _sectionid = sectionid;
        _current_modules = getModulesOfSection(_modules, _sectionid);
      });
    });
  }

  _goToModule(Module module) {
    switch (module.moduletype) {
      default:
        navigationMain.currentState.pushNamed('/webview',
            arguments: {"url": domen + module.moduleurl});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseid =
        (ModalRoute.of(context).settings.arguments as Map)["course"].courseid;
    final pid = (ModalRoute.of(context).settings.arguments as Map)["pid"];
    if (_courseid == 0) {
      setCourseId(courseid);
    }
    if (_pid == 0) {
      setPid(pid);
    }

    return new Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // page_header(header: 'Курс', paddings: [10, 10, 10, 0]),
        (_courses.length > 0) ? CourseInfo(courses: _courses) : Text(''),
        (_sections.length > 0)
            ? sections_page_view(
                callback: this.setSectionid, sections: _sections)
            : Text(''),
        // sections_page_view(callback: this.setSectionid, sections: _sections),
        page_header(header: 'Модули', paddings: [10, 0, 10, 0]),
        Expanded(
          child: Container(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: _current_modules.length,
              itemBuilder: (item, index) => Card(
                child: InkWell(
                  onTap: () => _goToModule(_current_modules[index]),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(children: [
                      Image.network(
                        _current_modules[index].moduleicon,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes
                                : null,
                          );
                        },
                        height: 25,
                        width: 25,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                          child: Text(
                            _current_modules[index].modulename,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ]),
                  ),
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

class CourseInfo extends StatelessWidget {
  const CourseInfo({
    Key key,
    @required List courses,
  })  : _courses = courses,
        super(key: key);

  final List _courses;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red[100],
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (_courses[0].teacherpicture != '')
              ? ClipOval(
                  child: Image.network(
                    domen + _courses[0].teacherpicture,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes
                            : null,
                      );
                    },
                    width: 100,
                    height: 100,
                  ),
                )
              : Text(''),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_courses[0].name,
                      style: Theme.of(context).textTheme.headline3,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis),
                  Text(
                    _courses[0].teacherlastname +
                        " " +
                        _courses[0].teacherfirstname,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
