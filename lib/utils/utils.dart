import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/models/lib_webinar.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:http/http.dart' as http;

// TOAST
void showToast(BuildContext context, {String text = null}) {
  final scaffold = Scaffold.of(context);
  var msg = (text != null) ? text : "Отсутствует интернет подключение";
  scaffold.showSnackBar(
    SnackBar(
      content: Text(msg),
      action: SnackBarAction(
          label: 'Закрыть', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

// API
@JsonSerializable(nullable: false)
class _Api {
  final int code;
  final String error;
  final String errorText;
  final List answer;

  _Api({this.code, this.error, this.errorText, this.answer});

  factory _Api.fromJson(Map<String, dynamic> json, {toList = false}) =>
      _$ApiFromJson(json, toList: toList);

  Map<String, dynamic> toJson() => _$ApiToJson(this);
}

_Api _$ApiFromJson(Map<String, dynamic> json, {toList = false}) {
  return _Api(
    code: json['code'] as int,
    error: json['error'].toString() as String,
    errorText: json['errorText'] as String,
    answer: (toList) ? [json['answer']] as List : json['answer'] as List,
  );
}

Map<String, dynamic> _$ApiToJson(_Api instance) => <String, dynamic>{
      'errotText': instance.errorText,
      'error': instance.error,
      'code': instance.code,
      'answer': instance.answer
    };

//POST
Future sendPost(method, body,
    {toList = false, hasToken = true, test = false}) async {
  var apiDomen = test ? test_domen : domen;
  var saltApi = salt;
  var apiUrl = '/local/api/mobile.php?salt=$saltApi&method=';
  var tokenQuery = hasToken ? '&token=$token' : '';
  var url = apiDomen + apiUrl + method + tokenQuery;
  // print(url);
  // print(body);
  var response = await http.post(url, body: body);
  var result = response.body;
  // print(result);
  if (response.statusCode != 200) {
    result = jsonEncode({
      'error': true,
      'code': response.statusCode,
      'answer': [],
      'errotText': response.statusCode
    });
  }
  // print(result);
  return responseTreatment(result, toList: toList);
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }
}
// void setupLocator() {
//   locator.registerLazySingleton(() => NavigationService());
// }

Future downloadsDirectory = DownloadsPathProvider.downloadsDirectory;

Future dowloadFile(fileUrl) async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  final taskId = await FlutterDownloader.enqueue(
    url: fileUrl,
    savedDir: downloadsDirectory.toString(),
    showNotification: true,
    // show download progress in status bar (for Android)
    openFileFromNotification:
        true, // click on notification to open downloaded file (for Android)
  );

  await FlutterDownloader.loadTasks();
  // FlutterDownloader.registerCallback(callback);
}

responseTreatment(resultQuery, {toList = false}) {
  var result = _Api.fromJson(jsonDecode(resultQuery), toList: toList);
  var answer = Map();
  if (result.code == 200) {
    answer['error'] = false;
    answer['answer'] = result.answer;
  } else {
    answer['error'] = true;
    answer['answer'] = result.errorText;
  }
  return answer;
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


Timer setTimeout(callback, [int duration = 1000]) {
  return Timer(Duration(milliseconds: duration), callback);
}

void clearTimeout(Timer t) {
  t.cancel();
}