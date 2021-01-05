import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart' as path;
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:json_annotation/json_annotation.dart';
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

Timer setTimeout(callback, [int duration = 1000]) {
  return Timer(Duration(milliseconds: duration), callback);
}

void clearTimeout(Timer t) {
  t.cancel();
}

//DOWNLOAD

Future<void> downloadFile(String url,
    [BuildContext context, Function recieveCallback]) async {
  // final String _fileUrl ='http://lot.services/blog/files/DSCF0277.jpg';
  final String _fileUrl = url;
  // print(_fileUrl);
  final dir = await _getDownloadDirectory();
  final isPermissionStatusGranted = await _requestPermissions();

  if (isPermissionStatusGranted) {
    await _startDownload(dir.path, _fileUrl, recieveCallback);
  } else {
    if (context != null) showToast(context, text: 'Ошибка загрузки файла');
  }
}

Future<Directory> _getDownloadDirectory() async {
  if (Platform.isAndroid) {
    return await DownloadsPathProvider.downloadsDirectory;
  }
  return await getApplicationDocumentsDirectory();
}

Future<bool> _requestPermissions() async {
  var permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  if (permission != PermissionStatus.granted) {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
  }
  return permission == PermissionStatus.granted;
}

Future<void> _startDownload(
    String pathDir, String fileurl, Function recieveCallback) async {
  final Dio _dio = Dio();
  var _filename = await _getFileNameFromUrl(_dio, fileurl);

  _filename = _getNewFileName(pathDir, _filename).toString();
  final _savePath = path.join(pathDir, _filename);
  // print(_filename);

  Map<String, dynamic> result = {
    'isSuccess': false,
    'filePath': null,
    'fileName': _filename,
    'error': null,
  };
  // to ask path fo saving;
  // final params = SaveFileDialogParams(sourceFilePath: "path_of_file_to_save");
  // final filePath = await FlutterFileDialog.saveFile(params: params);
  try {
    final response = await _dio.download(fileurl, _savePath,
        onReceiveProgress: recieveCallback);
    result['isSuccess'] = response.statusCode == 200;
    result['filePath'] = _savePath;
  } catch (ex) {
    result['error'] = ex.toString();
  } finally {
    await showNotificationDownload(result);
  }
}

Future<String> _getFileNameFromUrl(Dio dio, String url) async {
  var filename = '';

  File file = new File(url);
  String basename = path.basename(file.path);
  filename = basename;
  var items = filename.split('.');
  List extensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'jpg', 'png', 'zip', 'rar'];
  if(extensions.contains(items.last)) {
    filename = Uri.decodeComponent(filename);
    return filename;
  }
  try {
    Response response = await dio.head(url);
    var header = response.headers['content-disposition'][0];
    RegExp exp =
        new RegExp(r"""[\s\S]*?filename=[\'\"]?([\s\S]*?)[\'\"]""");
    var result = exp.allMatches(header).map((m) => m[1]);
    filename = result.toString().replaceAll(new RegExp(r'[()]'), '');
  } catch (e) {
    File file = new File(url);
    String basename = path.basename(file.path);
    filename = basename;
  }
  if (filename == '') filename = 'Документ';
  return filename;
}

_getNewFileName(pathDir, filename) {
  int num = 1;
  var newfilename;
  File file = new File(path.join(pathDir, filename));
  if (file.existsSync()) {
    while (file.existsSync()) {
      List items = filename.split('.');
      var extension = (items.length > 1) ? ('.' + items.last) : '';
      items.removeLast();
      newfilename = items.join('.') + ' (' + (num++).toString() + ')' + extension;
      file = new File(path.join(pathDir, newfilename));
    }
  } else {
    newfilename = filename;
  }
  return newfilename;
}

Future<void> showNotificationDownload(
    Map<String, dynamic> downloadStatus) async {
  final android = AndroidNotificationDetails(
      'channel id', 'channel name', 'channel description',
      priority: Priority.High, importance: Importance.Max);
  final iOS = IOSNotificationDetails();
  final platform = NotificationDetails(android, iOS);
  final json = jsonEncode(downloadStatus);
  final isSuccess = downloadStatus['isSuccess'];

  if (flutterLocalNotificationsPlugin != null)
    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Файл загружен' : 'Ошибка',
        isSuccess
            ? 'Файл ' + downloadStatus['fileName'] + ' успешно загружен!'
            : 'Ошибка при загрузке файла ' + downloadStatus['fileName'],
        platform,
        payload: json);
}
