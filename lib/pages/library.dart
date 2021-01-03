import 'package:flutter/material.dart';
import 'package:flutter_app_test/fragments/library_item.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';
import 'package:flutter_app_test/models/lib_webinar.dart';
import 'package:flutter_app_test/components/page_header.dart';

// import 'package:flutter_app_test/components/custom_divider.dart';
// import 'package:flutter_app_test/models/webinar.dart';
// import 'package:flutter_app_test/utils/settings.dart';



class Library extends StatefulWidget {
  static GlobalKey<NavigatorState> navigator;

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final _navigatonLibrary = GlobalKey<NavigatorState>();
  List _webinars = [];

  @override
  void initState() {
    Library.navigator = _navigatonLibrary;
    getWebinars(context, setWebinars, {});
    super.initState();
  }

  setWebinars(webinars) {
    setState(() {
      _webinars = webinars;
    });
  }

  _goToItem(LibWebinar webinar) {
    print(webinar.webinarid); //
    _navigatonLibrary.currentState
        .pushNamed('/item', arguments: {"webinar": webinar});
    // print(_navigatonLibrary.currentState.canPop());
    // Navigator.of(context).pushNamed('/item');
  }

  _goToList() {
    if (_navigatonLibrary.currentState.canPop())
      _navigatonLibrary.currentState.pop('/');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { _goToList(); },
      child: Navigator(
        key: _navigatonLibrary,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          // Manage your route names here
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => LibraryList();
              break;
            case '/item':
              builder = (BuildContext context) => LibraryItem();
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          // You can also return a PageRouteBuilder and
          // define custom transitions between pages
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        },
      ),
    );
  }

  Column LibraryList() {
    return new Column(
      children: [
        page_header(header: "Электронная библиотека"),
        Expanded(
          child: Container(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: _webinars.length,
              itemBuilder: (item, index) => Card(
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
