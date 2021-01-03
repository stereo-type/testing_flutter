import 'package:flutter_app_test/models/course.dart';
import 'package:flutter_app_test/models/lib_webinar.dart';
import 'package:flutter_app_test/models/modules.dart';
import 'package:flutter_app_test/models/sections.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';

navigateToModule(Module module) {
  switch (module.moduletype) {
    default:
      navigationMain.currentState.pushNamed('/webview',
          arguments: {"url": domen + module.moduleurl});
      break;
  }
}


getInitials(String firstname) {
  var str = firstname.replaceAll('   ', ' ');
  str = firstname.replaceAll('  ', ' ');
  var arr = str.split(" ");
  var initials;
  if (arr.length > 1)
    initials = arr[0][0] + "." + arr[1][0] + ".";
  else
    initials = arr[0][0] + ".";
  return initials;
}

getWebinars(context, callback, params, [need_common_data = true]) async {
  var result = await sendPost('getwebinars', params);
  if (result['error'] == false) {
    var data = result['answer'][0];
    var current_list_data = result['answer'];
    if (need_common_data) {
      var state = data['state'];
      var total_count = int.parse(data['count'].toString());
      var current_page = int.parse(data['page'].toString());
      var per_page = int.parse(data['perpage'].toString());
      current_list_data = data['list'];
    }
    var webinars = [];
    current_list_data.forEach((arrayItem) {
      webinars.add(LibWebinar(
          int.parse(arrayItem["id"].toString()),
          arrayItem["title"],
          arrayItem["author"],
          arrayItem["video"],
          arrayItem["poster"],
          arrayItem["description"],
          arrayItem["shorttitle"],
          arrayItem["autorpic"],
          arrayItem["videohttps"]));
    });
    callback(webinars);
  } else {
    showToast(context, text: result['answer']);
  }
}

getCourses(context, callback, pid, [courseid = 0]) async {
  var result = await sendPost('eduplan', {"id": pid.toString()});
  if (result['error'] == false) {
    var courses = [];
    result['answer'].forEach((arrayItem) {
      var teachers = arrayItem["teachers"];
      if (courseid == 0 ||
          int.parse(arrayItem["courseid"].toString()) == courseid) {
        courses.add(Course(
          int.parse(arrayItem["courseid"].toString()),
          arrayItem["name"],
          int.parse(arrayItem["isifer"].toString()),
          arrayItem["url"],
          int.parse(arrayItem["period"].toString()),
          arrayItem["iscompeted"],
          // (arrayItem["mobileaccess"] != null) ? arrayItem["mobileaccess"] : false,
          //TODO temporary
          (arrayItem["available"] != null) ? arrayItem["available"] : false,
          (!teachers.isEmpty) ? (teachers[0]["lastname"] ?? '') : '',
          (!teachers.isEmpty) ? (teachers[0]["firstname"] ?? '') : '',
          (!teachers.isEmpty) ? (teachers[0]["pictureurl"] ?? '') : '',
        ));
      }
    });
    // print(courses[1].available);
    callback(courses);
  } else {
    showToast(context, text: result['answer']);
  }
}

getSectionsFromModuleList(modules) {
  List sections = [];
  List sectionids = [];
  modules.forEach((arrayItem) {
    var section = Section(arrayItem.sectionid, arrayItem.sectionname);
    if (arrayItem.sectionname != null && arrayItem.sectionname != '' && sectionids.indexOf(arrayItem.sectionid) == -1) {
      sections.add(section);
      sectionids.add(arrayItem.sectionid);
    }
  });

  return sections;
}

getModulesOfSection(allmodules, sectionid) {
  List modules = [];
  allmodules.forEach((item) {
    if(item.sectionid == sectionid)
      modules.add(item);
  });
  return modules;
}

getModulesWithoutSection(allmodules) {
  List modules = [];
  allmodules.forEach((item) {
    if(item.sectionname == '')
      modules.add(item);
  });
  return modules;
}