import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var domen =  'https://sdo.adpo.edu.ru';
var test_domen =  'https://slava.sdo.support';
const salt = 'HGDGJHSJSJJSJ7777ssd';
var token = '0';

final navigationMain = GlobalKey<NavigatorState>();
const mainColor = Color(0xFF2875BC);
const secondColor = Colors.white;
const availableColor = Color(0xFF81BC27);
const alarmColor = Color(0xFFE84040);
const alarmTextColor = Color(0xFFE96F6F);
const alarmBackgroundColor = Color(0xFFFFF0F0);
const unAvailableColor = Color(0xFF808080);
const infoColor = Color(0x99CCE5FF);
var textColorNormal = Colors.grey[850];
var textColorDark = Colors.grey[900];
var textColorLight = Colors.grey[600];
var textColorLighter = Colors.grey[400];
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


const kDefaultRoundedBorderDecoration = BoxDecoration(
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.black,
  ),
  border: kDefaultRoundedBorder,
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
);

const Border kDefaultRoundedBorder = Border(
  top: kDefaultRoundedBorderSide,
  bottom: kDefaultRoundedBorderSide,
  left: kDefaultRoundedBorderSide,
  right: kDefaultRoundedBorderSide,
);

const BorderSide kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  style: BorderStyle.solid,
  width: 0.0,
);