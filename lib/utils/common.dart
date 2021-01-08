import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/dbhelper/db.dart';
import 'package:flutter_app_test/models/course.dart';
import 'package:flutter_app_test/models/lib_webinar.dart';
import 'package:flutter_app_test/models/modules.dart';
import 'package:flutter_app_test/models/sections.dart';
import 'package:flutter_app_test/models/user.dart';
import 'package:flutter_app_test/pages/home_page.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';

navigateToModule(Module module) {
  switch (module.moduletype) {
    case 'mvideo':
      navigationMain.currentState
          .pushNamed('/mvideo', arguments: {"id": module.moduleid});
      break;
    default:
      navigationMain.currentState
          .pushNamed('/webview', arguments: {"url": DOMAIN + module.moduleurl});
      break;
  }
}

logOut() {
  TOKEN = '0';
  BuildContext _context = navigationMain.currentContext;
  final db = DatabaseHelper.instance;
  db.delete_datebase();
  if (Navigator.of(_context).canPop()) {
    Navigator.of(_context).pop();
  }
  if (HomePage.of(_context) != null) {
    HomePage.of(_context).hideBars();
    HomePage.of(_context).updateWidget();
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
          (arrayItem["ifer"] != null)
              ? arrayItem["ifer"]
              : [
                  {"name": "", "assess": true}
                ],
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
    if (arrayItem.sectionname != null &&
        arrayItem.sectionname != '' &&
        sectionids.indexOf(arrayItem.sectionid) == -1) {
      sections.add(section);
      sectionids.add(arrayItem.sectionid);
    }
  });

  return sections;
}

getModulesOfSection(allmodules, sectionid) {
  List modules = [];
  allmodules.forEach((item) {
    if (item.sectionid == sectionid) modules.add(item);
  });
  return modules;
}

getModulesWithoutSection(allmodules) {
  List modules = [];
  allmodules.forEach((item) {
    if (item.sectionname == '') modules.add(item);
  });
  return modules;
}

getUserinfo(BuildContext context, DatabaseHelper db) async {
  var result = await sendPost('getuserinfo', {}, toList: true);
  if (result['error'] == false) {
    var item = result['answer'][0];
    User user = User(
      int.parse(item['id'].toString()),
      item['firstname'],
      item['lastname'],
      (item['email'] != null && item['email'] != '' && item['email'] != 'null')
          ? item['email']
          : '',
      (item['phone1'] != null &&
          item['phone1'] != '' &&
          item['phone1'] != 'null')
          ? item['phone1']
          : '',
      (item['avatar'] != null &&
          item['avatar'] != '' &&
          item['avatar'] != 'null')
          ? item['avatar']
          : '',
      (item['description'] != null &&
          item['description'] != '' &&
          item['description'] != 'null')
          ? item['description']
          : '',
    );
    await db.insert_record('user', user.toMap());
  } else {
    showToast(context, text: result['answer']);
  }
}
