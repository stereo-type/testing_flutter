import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/custom_divider.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/custom_icons.dart';
import 'package:flutter_app_test/models/lib_webinar_item.dart';
import 'package:flutter_app_test/models/modules/mvideo.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:path/path.dart' as path;

import 'dart:convert' show utf8;

getMvideo(context, callback, params) async {
  var result = await sendPost('getmvideo', params);
  if (result['error'] == false) {
    var webinars = [];
    result['answer'].forEach((arrayItem) {
      webinars.add(Mvideo(arrayItem["name"], arrayItem["url_mp4"]));
    });
    callback(webinars);
  } else {
    showToast(context, text: result['answer']);
  }
}

getWebinar(context, callback, params) async {
  var result = await sendPost('getwebinar', params, toList: true);
  if (result['error'] == false) {
    var data = result['answer'];
    var webinar = [];
    data.forEach((arrayItem) {
      webinar.add(LibWebinarItem(
          int.parse(arrayItem["id"].toString()),
          arrayItem["title"],
          arrayItem["imgUrl"],
          arrayItem["video"],
          (arrayItem["description"] !=null)?  arrayItem["description"] : '',
          int.parse(arrayItem["authorid"].toString()),
          (arrayItem["sections"] != null)
              ? arrayItem["sections"]
              : [
                  {'st': '', 'sd': ''}
                ]));
    });
    callback(webinar);
  } else {
    showToast(context, text: result['answer']);
  }
}

class LibraryItem extends StatefulWidget {
  final bool isLibrary;

  LibraryItem({this.isLibrary = true});

  @override
  _LibraryItemState createState() => _LibraryItemState();
}

class _LibraryItemState extends State<LibraryItem> {
  BetterPlayerController _betterPlayerController;
  List _item = [];
  int _itemid = 0;
  int _seconds = 0;
  String _videoName = '';
  var _teacherPic = null;
  bool is_init = false;

  @override
  void initState() {
    // if (_webid != 0) getWebinars(context, setWebinarData, {'id': _webid.toString()}, false);
    super.initState();
  }

  void setTeacherImg(img) {
    setState(() {
      _teacherPic = img;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_betterPlayerController != null) _betterPlayerController.dispose();
  }

  setItemId(itemid) {
    setState(() {
      _itemid = itemid;
      widget.isLibrary
          ? getWebinar(context, setItemData, {'id': _itemid.toString()})
          : getMvideo(context, setItemData, {'id': _itemid.toString()});
    });
  }

  setItemData(data) {
    setState(() {
      _item = data;
      var url = '';
      widget.isLibrary ? url = _item[0].video : url = _item[0].url;
      if (!widget.isLibrary) _videoName = _item[0].name;
      // print(url);
      // url= 'http://sample.vodobox.com/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8';
      // url =
      //     'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
      if (!is_init) {
        BetterPlayerDataSource betterPlayerDataSource =
            BetterPlayerDataSource(BetterPlayerDataSourceType.network, url);
        _betterPlayerController = BetterPlayerController(
            BetterPlayerConfiguration(
              autoPlay: true,
              allowedScreenSleep: false,
              startAt: Duration(seconds: _seconds),
              showPlaceholderUntilPlay: true,
            ),
            betterPlayerDataSource: betterPlayerDataSource);
        is_init = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemid = widget.isLibrary
        ? (ModalRoute.of(context).settings.arguments as Map)["webinar"]
            .webinarid
        : (ModalRoute.of(context).settings.arguments as Map)["id"];

    if (widget.isLibrary) {
      setTeacherImg(
          (ModalRoute.of(context).settings.arguments as Map)["webinar"]
              .autorpic);
    }

    if (_itemid == 0) {
      setItemId(itemid);
    }

    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: page_header(
                header:
                    widget.isLibrary ? "Электронная библиотека" : _videoName)),
        is_init
            ? AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(
                  controller: _betterPlayerController,
                ),
              )
            : Text(''),
        if (widget.isLibrary && _item.length > 0)
          AdditionalInfo(_item, _teacherPic)
      ],
    );
  }
}

class AdditionalInfo extends StatelessWidget {
  const AdditionalInfo(this.item, this.teacherPic, {Key key}) : super(key: key);

  final item;
  final teacherPic;

  _linkAction(url) {
    if (!url.contains('http')) {
      var newurl = domen +
          '/local/api/go.php?to=user&token=' +
          token +
          '&id=' +
          item[0].authorid.toString();
      navigationMain.currentState
          .pushNamed('/webview', arguments: {"url": newurl});
    } else {
      downloadFile(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(item[0].title);
    print(item[0].description);
    return Flexible(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.all(15),
        child: ListView(
          physics: BouncingScrollPhysics(),
          // shrinkWrap: true,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(item[0].title,
                    style: Theme.of(context).textTheme.headline3)),
            CustomDivider(),
            ListView.builder(
                shrinkWrap: true,
                // scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                itemCount: item[0].sections.length,
                itemBuilder: (_item, index) => Padding(
                      padding: EdgeInsets.all(0),
                      child:
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 10,
                              child: Container(
                                  width: double.infinity,
                                  child: Text(item[0].sections[index]['st'])),
                            ),
                            Flexible(
                                flex: 3,
                                child: SizedBox(
                                  width: 35,
                                  child: (item[0].sections[index]['st'] ==
                                              'Авторы/Ведущие' &&
                                          teacherPic != null)
                                      ? ClipOval(
                                          child: Image.network(
                                            teacherPic,
                                            loadingBuilder:
                                                (context, child, progress) {
                                              if (progress == null)
                                                return child;
                                              return CircularProgressIndicator(
                                                value: progress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? progress
                                                            .cumulativeBytesLoaded /
                                                        progress
                                                            .expectedTotalBytes
                                                    : null,
                                              );
                                            },
                                            width: 35,
                                            height: 35,
                                          ),
                                        )
                                      : (item[0].sections[index]['st'] !=
                                              'Продолжительность')
                                          ? Icon(
                                              CustomIcons.papersheet,
                                              size: 35,
                                              color: mainColor,
                                            )
                                          : Text(''),
                                )),
                            Flexible(
                              flex: 10,
                              child: Container(
                                width: double.infinity,
                                child: Html(
                                    onLinkTap: (url) {
                                      _linkAction(url);
                                    },
                                    data: item[0].sections[index]['sd']),
                              ),
                            ),
                          ]),
                    )),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: CustomDivider()),
            Text(item[0].description)
          ],
        ),
      ),
    );
  }
}
