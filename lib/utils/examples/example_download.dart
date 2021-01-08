import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart' as path;
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/utils.dart';

class ExempleDownload extends StatefulWidget {
  ExempleDownload({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ExempleDownloadState createState() => _ExempleDownloadState();
}

class _ExempleDownloadState extends State<ExempleDownload> {
  String _progress = "-";

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Download progress:',
            ),
            Text(
              '$_progress',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){downloadFile('http://lot.services/blog/files/DSCF0277.jpg', context, _onReceiveProgress);},
        tooltip: 'Download',
        child: Icon(Icons.file_download),
      ),
    );
  }
}
