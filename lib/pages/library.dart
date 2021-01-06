import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/models/lib_webinar.dart';
import 'package:flutter_app_test/utils/common.dart';
import 'package:flutter_app_test/components/page_header.dart';
import 'package:flutter_app_test/utils/utils.dart';

getWebinars(context, callback, params) async {
  var result = await sendPost('getwebinars', params);
  if (result['error'] == false) {
    var data = result['answer'][0];
    var current_list_data = result['answer'];
    var state = data['state'];
    var total_count = int.parse(data['count'].toString());
    var current_page = int.parse(data['page'].toString());
    var per_page = int.parse(data['perpage'].toString());
    current_list_data = data['list'];
    var webinars = [];
    current_list_data.forEach((arrayItem) {
      webinars.add(LibWebinar(
          int.parse(arrayItem["id"].toString()),
          arrayItem["title"],
          arrayItem["author"],
          arrayItem["video"],
          arrayItem["poster"],
          arrayItem["description"],
          arrayItem["shorttitle"],
          arrayItem["author_pic"],
          arrayItem["videohttps"]));
    });
    callback(webinars, total_count, state, current_page);
  } else {
    showToast(context, text: result['answer']);
  }
}

class Library extends StatefulWidget {
  static GlobalKey<NavigatorState> navigator;

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final _navigatonLibrary = GlobalKey<NavigatorState>();
  ScrollController _scrollController = ScrollController();
  TextEditingController _textController = TextEditingController();

  List _webinars = [];
  int _offsetLoad = 0;
  int _page = 0;
  int _perpage = 20;
  int _count = 0;
  int _max = 40;
  String _filter = '';
  String _state = 'open';
  String _search = '';

  @override
  void initState() {
    Library.navigator = _navigatonLibrary;
    getWebinars(context, setWebinars, {
      'page': _page.toString(),
      'perpage': _perpage.toString(),
      'filter': _filter.toString()
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_count < _max) _getMoreData();
      }
    });
    super.initState();
  }

  setWebinars(webinars, count, state, page) {
    setState(() {
      _webinars = webinars;
      _count = webinars.length;
      _max = count;
      _state = state;
      _page = page;
    });
  }

  addWebinars(webinars, count, state, page) {
    setState(() {
      _webinars.addAll(webinars);
      _count += webinars.length;
      _max = count;
      _state = state;
      _page = page;
    });
  }

  setFilter(filter) {
    setState(() {
      _filter = filter;
      _count = 0;
      _page = 0;
      _max = 40;
      getWebinars(context, setWebinars, {
        'page': _page.toString(),
        'perpage': _perpage.toString(),
        'filter': _filter.toString()
      });
    });
  }

  _getMoreData() {
    _page++;
    getWebinars(context, addWebinars, {
      'page': _page.toString(),
      'perpage': _perpage.toString(),
      'filter': _filter.toString()
    });
    setState(() {});
  }

  _goToItem(LibWebinar webinar) {
    navigationMain.currentState
        .pushNamed('/libraryitem', arguments: {"webinar": webinar});
  }

  @override
  Widget build(BuildContext context) {
    return LibraryList();
  }

  Column LibraryList() {
    return new Column(
      children: [
        page_header(header: "Электронная библиотека"),
        searchField(setFilter, _textController),
        Expanded(
          child: Container(
            child: ListView.builder(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10),
                itemCount: _webinars.length + 1,
                itemBuilder: (item, index) {
                  if (index == _webinars.length) {
                    if (_count < _max) {
                      return Padding(
                          padding: EdgeInsets.all(10),
                          child: CupertinoActivityIndicator(
                            radius: 15,
                          ));
                    } else {
                      return Text('');
                    }
                  }
                  return Card(
                    child: InkWell(
                      onTap: () => _goToItem(_webinars[index]),
                      child: Container(
                        height: 90,
                        child: Row(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7.0),
                                bottomLeft: Radius.circular(7.0)),
                            child: Image.network(
                              _webinars[index].poster,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes
                                      : null,
                                );
                              },
                              fit: BoxFit.fill,
                              height: 90,
                              width: 120,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                              child: Text(
                                _webinars[index].name,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    margin: EdgeInsets.all(5),
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class searchField extends StatelessWidget {
  const searchField(
    this.callback,
    this.controller,{
    Key key,
  }) : super(key: key);
  final Function callback;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        child: Stack(children: [
          CupertinoTextField(
            controller: controller,
            padding: EdgeInsets.fromLTRB(30, 5, 5, 5),
            placeholder: 'Поиск',
            onSubmitted: (String value) async {
              callback(value);
            },
          ),
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              alignment: Alignment.center,
              padding: EdgeInsets.all(0),
              iconSize: 22,
              icon: Icon(Icons.search, color: textColorLighter),
              onPressed: () {callback(controller.text);},
            ),
          ),
        ]));
  }
}
