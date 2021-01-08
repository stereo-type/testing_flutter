import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/autorization_bottom_bar.dart';
import 'package:flutter_app_test/components/drop_down.dart';
import 'package:flutter_app_test/components/my_button.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/custom_icons.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';

sendCall(context, name, phone, time, text) async {
  //Custom validation because of cupertino
  if (name.isEmpty || phone.isEmpty || text.isEmpty) {
    var content = 'Поле ';
    if (name.isEmpty)
      content += 'ввода имени';
    else if (phone.isEmpty)
      content += 'номера телефона';
    else if (text.isEmpty) content += 'вопроса';
    content += ' не может быть пустым.';
    return showAlert(context, 'Ошибка отправки формы', content);
  }

  var result = await sendPost(
      'sendcall',
      {
        'fio': name.toString(),
        'phone': phone.toString(),
        'text': text.toString(),
        'times': time.toString()
      },
      toList: true);
  if (result['error'] == false) {
    showAlert(context, 'Вы заказали звонок', result['answer'][0]);
    navigationMain.currentState.pop('/');
  } else {
    showAlert(context, 'Ошибка отправки формы', result['answer']);
  }
}

class AskCall extends StatefulWidget {
  @override
  _AskCallState createState() => _AskCallState();
}

class _AskCallState extends State<AskCall> {
  final _formCallKey = GlobalKey<FormState>();
  final _firstNode = FocusNode();
  final _secondNode = FocusNode();
  final _thirdNode = FocusNode();
  final _fourthNode = FocusNode();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _questionController = TextEditingController();
  var _dropDownValue = '9-12 час';
  List<String> _questions = ['12-15 час', '15-18 час', '18-21 час'];

  _changedValue(value) {
    setState(() {
      _dropDownValue = value;
      _firstNode.unfocus();
      FocusScope.of(context).requestFocus(_secondNode);
    });
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            page_header(
              header: 'Обратный звонок',
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
          CallForm(context),
          SizedBox(
            width: double.infinity,
            height: 120,
          ),
          AutorizationBottomBar(
              colors: [unAvailableColor, mainColor, unAvailableColor]),
        ],
      ),
    );
  }

  Container CallForm(BuildContext context) {
    return Container(
      child: Form(
        key: _formCallKey,
        child: Column(children: [
          Row(
            children: [
              Flexible(
                  flex: 4,
                  child: Text('Выберите удобное время для обратного звонка:')),
              Flexible(
                flex: 3,
                child: MyDropDown(
                  '9-12 час',
                  _dropDownValue,
                  _changedValue,
                  _questions,
                  focusNode: _firstNode,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 10,
          ),
          CupertinoTextField(
            controller: _nameController,
            focusNode: _secondNode,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            placeholder: 'Имя',
            textInputAction: TextInputAction.next,
            onSubmitted: (String value) async {
              _secondNode.unfocus();
              FocusScope.of(context).requestFocus(_thirdNode);
            },
          ),
          SizedBox(
            width: double.infinity,
            height: 10,
          ),
          CupertinoTextField(
            controller: _phoneController,
            focusNode: _thirdNode,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            placeholder: 'Телефон',
            textInputAction: TextInputAction.next,
            onSubmitted: (String value) async {
              _thirdNode.unfocus();
              FocusScope.of(context).requestFocus(_fourthNode);
            },
          ),
          SizedBox(
            width: double.infinity,
            height: 10,
          ),

          CupertinoTextField(
            focusNode: _fourthNode,
            maxLines: 5,
            controller: _questionController,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            placeholder: 'Вопрос',
            textInputAction: TextInputAction.send,
            onSubmitted: (String value) async {
              if (_formCallKey.currentState.validate()) {
                await sendCall(
                    context,
                    _nameController.text,
                    _phoneController.text,
                    _dropDownValue,
                    _questionController.text);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
            child: MyButton(
              padding: 12.0,
              width: double.infinity,
              text: "Заказать звонок",
              callback: () async {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formCallKey.currentState.validate()) {
                  await sendCall(
                      context,
                      _nameController.text,
                      _phoneController.text,
                      _dropDownValue,
                      _questionController.text);
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
