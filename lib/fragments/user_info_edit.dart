import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/my_button.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/models/user_info.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/common.dart';
import 'package:flutter_app_test/utils/utils.dart';

savePersonalData(context, callback, params) async{
    var result = await sendPost('savepersonaldata', params);
    if (result['error'] == false) {
      callback();
    } else {
      showToast(context, text: result['answer']);
    }
}


class UserInfoEdit extends StatefulWidget {
  @override
  _UserInfoEditState createState() => _UserInfoEditState();
}

class _UserInfoEditState extends State<UserInfoEdit> {
  final _formUserKey = GlobalKey<FormState>();
  final _firstNode = FocusNode();
  final _secondNode = FocusNode();
  final _thirdNode = FocusNode();
  final _fourthNode = FocusNode();

  final _cityController = TextEditingController();
  final _institutionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _descriptionController = TextEditingController();

  UserInfo _user;

  @override
  initState() {
    super.initState();
    updateUser();
  }

  setUser(user) {
    setState(() {
      _user = user;
      _cityController.text = _user.city;
      _institutionController.text = _user.institution;
      _departmentController.text = _user.department;
      _descriptionController.text = _user.description;
    });
  }

  updateUser() {
    getData(context, setUser, 0);
    setState(() {});
  }

  sendUserData() {
    Map params = {
      'city': _cityController.text,
      'institution': _institutionController.text,
      'department': _departmentController.text,
      'description': _descriptionController.text,
    };
    savePersonalData(context, updateUser, params);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      PageHeader(header: 'Профиль'),
      Container(
        padding: EdgeInsets.all(10),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (USER['avatar'] != '')
                  ? ClipOval(
                      child: Image.network(
                        USER['avatar'],
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes
                                : null,
                          );
                        },
                        width: 80,
                        height: 80,
                      ),
                    )
                  : Text(''),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          USER['lastname'] + " " + USER['firstname'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(USER['email'],
                          style: Theme.of(context).textTheme.headline3,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      UserForm(context),
    ]);
  }

  Container UserForm(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formUserKey,
          child: Column(
            children: [
              CupertinoTextField(
                controller: _cityController,
                focusNode: _firstNode,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                placeholder: 'Город',
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
                controller: _institutionController,
                focusNode: _secondNode,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                placeholder: 'Должность',
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
                controller: _departmentController,
                focusNode: _thirdNode,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                placeholder: 'Организация',
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
                controller: _descriptionController,
                focusNode: _fourthNode,
                maxLines: 5,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                placeholder: 'Описание',
                textInputAction: TextInputAction.send,
                onSubmitted: (String value) async {
                  if (_formUserKey.currentState.validate()) {
                    await sendUserData();
                  }
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                child: MyButton(
                  padding: 12.0,
                  width: double.infinity,
                  text: "Отправить",
                  callback: () async {
                    if (_formUserKey.currentState.validate()) {
                      await sendUserData();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
