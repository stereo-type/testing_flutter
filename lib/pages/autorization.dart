import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/autorization_bottom_bar.dart';
import 'package:flutter_app_test/components/my_button.dart';
import 'package:flutter_app_test/custom_icons.dart';
import 'package:flutter_app_test/dbhelper/db.dart';
import 'package:flutter_app_test/pages/home_page.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';

class Autorization extends StatefulWidget {
  Autorization({Key key}) : super(key: key);

  @override
  _Autorization createState() => _Autorization();
}

/// This is the private State class that goes with MyStatefulWidget.
class _Autorization extends State<Autorization> {
  final _formKey = GlobalKey<FormState>();
  final _firstNode = FocusNode();
  final _secondNode = FocusNode();
  final _loginController = TextEditingController();
  final _passController = TextEditingController();
  final db = DatabaseHelper.instance;

  final _anounsment =
      'Документ о квалификации (об обучении) оформляется в течение 10-и рабочих дней после успешного прохождения итоговой аттестации. Ожидайте, пожалуйста, сообщение о готовности по электронной почте.';

  tryLogin() async {
    var login = _loginController.text;
    var password = _passController.text;
    var result = await sendPost(
        'auth', {'username': login, 'password': password},
        toList: true, hasToken: false);
    if (result['error'] == false) {
      String token = result['answer'][0]['token'];
      await db.delete_datebase();
      var record = await db.insert_record('token', {'token': token});
      HomePage.of(context).setToken(token);
    } else {
      showToast(context, text: result['answer']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/logoheader.png',
            width: 180,
            height: 70,
          ),
          Container(
            decoration: BoxDecoration(
                color: infoColor, borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(top: 30, bottom: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      CustomIcons.info,
                      color: mainColor,
                      size: 16,
                    )),
                Expanded(child: Text(_anounsment)),
              ],
            ),
          ),
          LoginForm(context),
          SizedBox(
            width: double.infinity,
            height: 10,
          ),
          GestureDetector(
            onTap: () {
             navigationMain.currentState.pushNamedWithoutHistoryIfNotCurrent('/forgot_password');
            },
            child: Text('Забыли пароль?'),
          ),
          SizedBox(
            width: double.infinity,
            height: 150,
          ),
          AutorizationBottomBar(),
        ],
      ),
    );
  }

  Container LoginForm(BuildContext context) {
    return Container(
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                textAlign: TextAlign.center,
                controller: _loginController,
                textInputAction: TextInputAction.next,
                focusNode: _firstNode,
                onFieldSubmitted: (String val) {
                  _firstNode.unfocus();
                  FocusScope.of(context).requestFocus(_secondNode);
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    borderSide: BorderSide(color: unAvailableColor),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    borderSide: BorderSide(color: alarmColor, width: 2),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    borderSide: BorderSide(color: alarmColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    borderSide: BorderSide(color: mainColor),
                  ),
                  hintText: 'Логин',
                  contentPadding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Поле логин не может быть пустым';
                  }
                  return null;
                },
              ),
              TextFormField(
                textAlign: TextAlign.center,
                controller: _passController,
                textInputAction: TextInputAction.send,
                onFieldSubmitted: (String val) {
                  _formKey.currentState.validate();
                  if (_formKey.currentState.validate()) {
                    tryLogin();
                  }
                },
                focusNode: _secondNode,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    borderSide: BorderSide(color: unAvailableColor),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    borderSide: BorderSide(color: alarmColor, width: 2),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    borderSide: BorderSide(color: alarmColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    borderSide: BorderSide(color: mainColor),
                  ),
                  hintText: 'Пароль',
                  contentPadding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Поле пароля не может быть пустым';
                  }
                  return null;
                },
              ),
              SizedBox(
                width: double.infinity,
                height: 30,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                child: MyButton(
                  padding: 12.0,
                  width: double.infinity,
                  text: "Войти",
                  callback: () async {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      tryLogin();
                    }
                  },
                ),
              ),
            ]),
          ),
        );
  }
}
