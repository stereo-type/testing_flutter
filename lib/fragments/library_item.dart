import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/utils/common.dart';

class LibraryItem extends StatefulWidget {
  @override
  _LibraryItemState createState() => _LibraryItemState();
}

class _LibraryItemState extends State<LibraryItem> {
  BetterPlayerController _betterPlayerController;
  List _webinar = [];
  int _webid = 0;
  int _seconds = 5;
  bool is_init = false;

  @override
  void initState() {
    // if (_webid != 0) getWebinars(context, setWebinarData, {'id': _webid.toString()}, false);
    super.initState();
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  setWebinarId(webinarid) {
    setState(() {
      _webid = webinarid;
      getWebinars(context, setWebinarData, {'id': _webid.toString()}, false);
    });
  }

  setWebinarData(data) {
    setState(() {
      _webinar = data;
      var url = '';
      url = data[0].video;
      url =
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
      if (!is_init) {
        is_init = true;
        BetterPlayerDataSource betterPlayerDataSource =
            BetterPlayerDataSource(BetterPlayerDataSourceType.network, url);
        _betterPlayerController = BetterPlayerController(
            BetterPlayerConfiguration(
              autoPlay: true,
              allowedScreenSleep: false,
              startAt: Duration(seconds: _seconds),
            ),
            betterPlayerDataSource: betterPlayerDataSource);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final webid =
        (ModalRoute.of(context).settings.arguments as Map)["webinar"].webinarid;

    if (_webid == 0) {
      setWebinarId(webid);
    }

    return Column(
      children: [
        page_header(header: "Электронная библиотека"),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(
            controller: _betterPlayerController,
          ),
        ),
      ],
    );
  }
}

