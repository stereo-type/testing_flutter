import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/my_button.dart';
import 'package:flutter_app_test/utils/common.dart';


class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<
    UserInfoPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
          child: MyButton(
            padding: 12.0,
            width: double.infinity,
            text: "Выйти",
            callback: logOut
          ),
        ),
      ],
    );
  }
}


