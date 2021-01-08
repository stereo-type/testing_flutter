import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/custom_icons.dart';
import 'package:flutter_app_test/pages/home_page.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';

class userLogo extends StatefulWidget {
  const userLogo(this._user, {Key key, this.size = 40.0}) : super(key: key);
  final double size;
  final Map<String, dynamic> _user;

  @override
  _userLogoState createState() => _userLogoState();
}

class _userLogoState extends State<userLogo> {
  @override
  void initState() {
    super.initState();
  }

  _goToUserInfoPage() {
    BuildContext _context = navigationMain.currentContext;
    if (HomePage.of(_context) != null) {
      HomePage.of(_context).closeDrawer();
    }
    Navigator.of(_context).pushNamedIfNotCurrent('/user_info');
  }

  @override
  Widget build(BuildContext context) {
    return (widget._user == null)
        ? GestureDetector(
            onTap: _goToUserInfoPage,
            child: ClipOval(
              child: Icon(
                CustomIcons.user_study,
                size: 35,
                color: mainColor,
              ),
            ),
          )
        : GestureDetector(
            onTap: _goToUserInfoPage,
            child: ClipOval(
              child: Image.network(
                widget._user['avatar'],
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes
                        : null,
                  );
                },
                width: widget.size,
                height: widget.size,
              ),
            ),
          );
  }
}
