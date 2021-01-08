import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/autorization_bottom_bar.dart';
import 'package:flutter_app_test/components/my_button.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/custom_icons.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';

sendFogotPassword(context, name) async {
  //Custom validation because of cupertino
  if (name.isEmpty) {
    var content = 'Поле ';
    if (name.isEmpty)
      content += 'ввода логина';
    content += ' не может быть пустым.';
    return showAlert(context, 'Ошибка отправки формы', content);
  }

  var result = await sendPost(
      'forgotpassword',
      {
        'username': name.toString(),
      },
      toList: true);
  if (result['error'] == false) {
    showAlert(context, 'Проверьте свой почтовый ящик', result['answer'][0]);
    navigationMain.currentState.pop('/');
  } else {
    showAlert(context, 'Ошибка отправки формы', result['answer']);
  }
}

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formCallKey = GlobalKey<FormState>();
  final _firstNode = FocusNode();
  final _nameController = TextEditingController();

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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            page_header(
              header: 'Восстановление пароля',
              paddings: [0, 0, 0, 0],
            ),
            IconButton(
              padding: EdgeInsets.all(0),
              alignment: Alignment.centerRight,
              icon: Icon(
                CustomIcons.cancel,
                color: textColorDark,
                size: 18,
              ),
              onPressed: () {
                navigationMain.currentState.pop('/');
              },
            )
          ]),
          ForgotPasswordForm(context),
          SizedBox(
            width: double.infinity,
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 180,
          ),
          AutorizationBottomBar(
              colors: [unAvailableColor, mainColor, unAvailableColor]),
        ],
      ),
    );
  }

  Container ForgotPasswordForm(BuildContext context) {
    return Container(
      child: Form(
        key: _formCallKey,
        child: Column(children: [
          CupertinoTextField(
            focusNode: _firstNode,
            controller: _nameController,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            placeholder: 'Введите свой логин или email',
            textInputAction: TextInputAction.send,
            onSubmitted: (String value) async {
              if (_formCallKey.currentState.validate()) {
                await sendFogotPassword(
                    context,
                    _nameController.text);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
            child: MyButton(
              padding: 12.0,
              width: double.infinity,
              text: "Отправить",
              callback: () async {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formCallKey.currentState.validate()) {
                  await sendFogotPassword(
                      context,
                      _nameController.text);
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
