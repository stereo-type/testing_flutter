import 'package:flutter/material.dart';
import 'package:flutter_app_test/pages/home_page.dart';
import 'package:flutter_app_test/utils/utils.dart';

class Autorization extends StatefulWidget {
  Autorization({Key key}) : super(key: key);

  @override
  _Autorization createState() => _Autorization();
}

/// This is the private State class that goes with MyStatefulWidget.
class _Autorization extends State<Autorization> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passController = TextEditingController();
  final _firstNode = FocusNode();
  final _secondNode = FocusNode();

  tryLogin() async {
    var login = _loginController.text;
    var password = _passController.text;
    var result = await sendPost(
        'auth', {'username': login, 'password': password},
        toList: true, hasToken: false);
    if (result['error'] == false) {
      HomePage.of(context).setToken(result['answer'][0]['token']);
    } else {
      showToast(context, text: result['answer']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _loginController,
            textInputAction: TextInputAction.next,
            focusNode: _firstNode,
            onFieldSubmitted: (String val) {
              _firstNode.unfocus();
              FocusScope.of(context).requestFocus(_secondNode);
            },
            decoration: const InputDecoration(
              hintText: 'Введите логин',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Поле логин не может быть пустым';
              }
              return null;
            },
          ),
          TextFormField(
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
              hintText: 'Введите пароль',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Поле пароля не может быть пустым';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  tryLogin();
                }
              },
              child: Text('Войти'),
            ),
          ),
        ],
      ),
    );
  }
}
