import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/settings.dart';
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
Future sendPost(method, body, {toList = false, hasToken = true}) async {
  var apiDomen = domen;
  var saltApi = salt;
  var apiUrl = '/local/api/mobile.php?salt=$saltApi&method=';
  var tokenQuery = hasToken ? '&token=$token' : '';
  var url = apiDomen + apiUrl + method + tokenQuery;
  // print(url);
  var response = await http.post(url, body: body);
  var result = response.body;
  if (response.statusCode != 200) {
    result = jsonEncode({
      'error': true,
      'code': response.statusCode,
      'answer': [],
      'errotText': response.statusCode
    });
  }
  return responseTreatment(result, toList: toList);
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
