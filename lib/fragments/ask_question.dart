import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/autorization_bottom_bar.dart';
import 'package:flutter_app_test/components/drop_down.dart';
import 'package:flutter_app_test/components/my_button.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/custom_icons.dart';
import 'package:flutter_app_test/models/question.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';

getListOfQuestions(context, callback) async {
  var result = await sendPost('getallthemesforquestions', {});
  if (result['error'] == false) {
    List questions = [];
    result['answer'].forEach((arrayItem) {
      questions.add(
          Question(int.parse(arrayItem["id"].toString()), arrayItem["name"]));
    });
    callback(questions);
  } else {
    showToast(context, text: result['answer']);
  }
}

sendQuestion(context, fio, email, questionid, text) async {
  //Custom validation because of cupertino
  if (fio.isEmpty || email.isEmpty || text.isEmpty || questionid == -1) {
    var content = 'Поле ';
    if (fio.isEmpty)
      content += 'ФИО';
    else if (email.isEmpty)
      content += 'Email';
    else if (text.isEmpty)
      content += 'обращения';
    else if (questionid == -1) content += 'выбора темы обращения';
    content += ' не может быть пустым.';
    return showAlert(context, 'Ошибка отправки формы', content);
  }

  var result = await sendPost(
      'sendquestion',
      {
        'fio': fio.toString(),
        'email': email.toString(),
        'text': text.toString(),
        'who': questionid.toString()
      },
      toList: true);
  if (result['error'] == false) {
    showAlert(context, 'Ваш вопрос отправлен', result['answer'][0]);
    navigationMain.currentState.pop('/');
  } else {
    showAlert(context, 'Ошибка отправки формы', result['answer']);
  }
}

class AskQuestion extends StatefulWidget {
  @override
  _AskQuestionState createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  final _formQuestionKey = GlobalKey<FormState>();
  final _firstNode = FocusNode();
  final _secondNode = FocusNode();
  final _thirdNode = FocusNode();
  final _fourthNode = FocusNode();
  final _fioController = TextEditingController();
  final _emailController = TextEditingController();
  final _questionController = TextEditingController();
  var _dropDownValue = 'Тема Вашего обращения';
  List _questionInstances = [];
  List<String> _questions = [];
  int _selectedQuestionId = -1;

  @override
  initState() {
    super.initState();
    getListOfQuestions(context, _setQuestionsInstances);
  }

  _changedValue(value) {
    setState(() {
      _dropDownValue = value;
      var index = _questions.indexOf(value);
      if (index != -1) {
        _selectedQuestionId = _questionInstances[index].id;
      } else
        _selectedQuestionId = index;

      _thirdNode.unfocus();
      FocusScope.of(context).requestFocus(_fourthNode);
    });
  }

  _setQuestions(questions) {
    setState(() {
      _questions = questions;
    });
  }

  _setQuestionsInstances(questions) {
    setState(() {
      _questionInstances = questions;
      List<String> q = [];
      _questionInstances.forEach((element) {
        q.add(element.name);
      });
      _setQuestions(q);
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
            page_header(header: 'Задать вопрос', paddings: [0, 0, 0, 0]),
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
          QuestionForm(context),
          SizedBox(
            width: double.infinity,
            height: 120,
          ),
          AutorizationBottomBar(
              colors: [unAvailableColor, unAvailableColor, mainColor]),
        ],
      ),
    );
  }

  Container QuestionForm(BuildContext context) {
    return Container(
      child: Form(
        key: _formQuestionKey,
        child: Column(children: [
          CupertinoTextField(
            controller: _fioController,
            focusNode: _firstNode,
            padding: EdgeInsets.all(15),
            placeholder: 'ФИО',
            textInputAction: TextInputAction.next,
            onSubmitted: (String value) async {
              _firstNode.unfocus();
              FocusScope.of(context).requestFocus(_secondNode);
            },
          ),
          SizedBox(
            width: double.infinity,
            height: 10,
          ),
          CupertinoTextField(
            controller: _emailController,
            focusNode: _secondNode,
            padding: EdgeInsets.all(15),
            placeholder: 'Введите контактный email',
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
          MyDropDown(
            'Тема Вашего обращения',
            _dropDownValue,
            _changedValue,
            _questions,
            focusNode: _thirdNode,
          ),
          SizedBox(
            width: double.infinity,
            height: 10,
          ),
          CupertinoTextField(
            focusNode: _fourthNode,
            maxLines: 5,
            controller: _questionController,
            padding: EdgeInsets.all(15),
            placeholder: 'Текст обращения',
            textInputAction: TextInputAction.send,
            onSubmitted: (String value) async {
              if (_formQuestionKey.currentState.validate()) {
                await sendQuestion(
                    context,
                    _fioController.text,
                    _emailController.text,
                    _selectedQuestionId,
                    _questionController.text);
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
                if (_formQuestionKey.currentState.validate()) {
                  await sendQuestion(
                      context,
                      _fioController.text,
                      _emailController.text,
                      _selectedQuestionId,
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
