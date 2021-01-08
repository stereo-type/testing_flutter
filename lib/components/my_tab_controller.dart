import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/models/certificat.dart';
import 'package:flutter_app_test/pages/webinars.dart';
import 'package:flutter_app_test/utils/settings.dart';

class MyTabController extends StatefulWidget {
  const MyTabController(
    this.headers,
    this.loadingState,
    this.lists,
    this.cards,
    this.callbacks, {
    Key key,
  }) : super(key: key);
  final List<String> headers;
  final bool loadingState;
  final List<List<dynamic>> lists;
  final List<Function> cards;
  final List<Function> callbacks;

  @override
  _MyTabControllerState createState() => _MyTabControllerState();
}

class _MyTabControllerState extends State<MyTabController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Expanded(
        child: Column(
          children: <Widget>[
            TabBar(
              indicatorColor: mainColor,
              tabs: <Widget>[
                Tab(
                    child: Text(widget.headers[0].toUpperCase(),
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))),
                Tab(
                    child: Text(widget.headers[1].toUpperCase(),
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))),
              ],
            ),
            (widget.loadingState)
                ? Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      backgroundColor: mainColor,
                    ),
                  )
                : Container(
                    child: Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          Container(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(10),
                              itemCount: widget.lists[0].length,
                              itemBuilder: (course, index) => widget.cards[0](
                                  widget.lists[0], index, widget.callbacks[0]),
                            ),
                          ),
                          Container(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(10),
                              itemCount: widget.lists[1].length,
                              itemBuilder: (course, index) => widget.cards[1](
                                  widget.lists[1], index, widget.callbacks[1]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
