import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/components/sections_page_view.dart';
import 'package:flutter_app_test/models/modules.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';
import 'package:flutter_app_test/utils/common.dart';

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
  List _sections = [];
  List _offsections = [];
  List _current_modules = [];
  int _pid = 0;
  int _courseid = 0;
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
      _offsections = getModulesWithoutSection(_modules);
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
        (_courses.length > 0)
            ? CourseInfo(courses: _courses, offsections: _offsections)
            : Text(''),
        (_sections.length > 0)
            ? sections_page_view(
                callback: this.setSectionid, sections: _sections)
            : Text(''),
        page_header(header: 'Модули', paddings: [10, 0, 10, 0]),
        Expanded(
          child: ModulesList(current_modules: _current_modules, vertical: true),
        ),
      ],
    );
  }
}

class ModulesList extends StatelessWidget {
  const ModulesList({
    Key key,
    @required List current_modules,
    @required bool vertical = true,
  })  : _current_modules = current_modules,
        _orientation_vertical = vertical,
        super(key: key);

  final List _current_modules;
  final bool _orientation_vertical;

  @override
  Widget build(BuildContext context) {
    Map _settings;
    ScrollController _scrolController;

    var settings = {
      "vertical": {
        "cardColor": Colors.white,
        "mainPaddings": 10.0,
        "innerPaddings": 10.0,
        "iconSize": 25.0,
        "elevation": 7.0,
        "scrollbarAlwaisShown": false,
      },
      "horizontal": {
        "mainPaddings": 2.0,
        "innerPaddings": 5.0,
        "cardColor": Colors.yellow[200],
        "iconSize": 18.0,
        "elevation": 1.0,
        "scrollbarAlwaisShown": true,
      }
    };

    _settings =
        _orientation_vertical ? settings["vertical"] : settings["horizontal"];
    _scrolController = ScrollController();

    return Container(
      child: Scrollbar(
        thickness: 4,
        radius: Radius.circular(4),
        isAlwaysShown: _settings["scrollbarAlwaisShown"],
        controller: _scrolController,
        child: ListView.builder(
          controller: _scrolController,
          scrollDirection:
              _orientation_vertical ? Axis.vertical : Axis.horizontal,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(_settings["mainPaddings"]),
          itemCount: _current_modules.length,
          itemBuilder: (item, index) => Card(
            color: _settings["cardColor"],
            child: InkWell(
              onTap: () => navigateToModule(_current_modules[index]),
              child: Container(
                padding: EdgeInsets.all(_settings["innerPaddings"]),
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
                    height: _settings["iconSize"],
                    width: _settings["iconSize"],
                  ),
                  _orientation_vertical
                      ? Expanded(
                          child: ModuleItem(
                              current_modules: _current_modules, index: index),
                        )
                      : ModuleItem(
                          current_modules: _current_modules, index: index),
                ]),
              ),
            ),
            margin: EdgeInsets.all(5),
            elevation: _settings["elevation"],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          ),
        ),
      ),
    );
  }
}

class CourseInfo extends StatelessWidget {
  const CourseInfo({
    Key key,
    @required List courses,
    @required List offsections,
  })  : _courses = courses,
        _offsections = offsections,
        super(key: key);

  final List _courses;
  final List _offsections;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: IntrinsicHeight(
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
                padding: EdgeInsets.only(left: 15, right: 5),
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
                    SizedBox(
                      height: 15,
                    ),
                    (_offsections.length > 0)
                        ? Container(
                            height: 50,
                            child: ModulesList(
                                current_modules: _offsections, vertical: false))
                        : Text("")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModuleItem extends StatelessWidget {
  const ModuleItem({
    Key key,
    @required List current_modules,
    @required int index,
  })  : _current_modules = current_modules,
        _index = index,
        super(key: key);

  final List _current_modules;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
      child: Text(
        _current_modules[_index].modulename,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyText2,
        // style: TextStyle(fontSize: 14),
      ),
    );
  }
}
