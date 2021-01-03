import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final url = (ModalRoute.of(context).settings.arguments as Map)["url"];
    print(url);

    return WebView(
        initialUrl: url, javascriptMode: JavascriptMode.unrestricted);
    /*return Container(
      width: 350,
      height: 500,
      child: new Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WebView(
              initialUrl:
                  'https://sdo.adpo.edu.ru/local/api/go.php?token=296cb3a0-8ff9-4d1d-a1af-71a9b1020add&to=mod&type=book&id=156895',
              javascriptMode: JavascriptMode.unrestricted)
        ],
      ),
    );*/
  }
}
