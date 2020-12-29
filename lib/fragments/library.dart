import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/settings.dart';
import 'package:flutter_app_test/utils/utils.dart';
import 'package:flutter_app_test/models/lib_webinar.dart';
import 'package:flutter_app_test/components/page_header.dart';

// import 'package:flutter_app_test/components/custom_divider.dart';
// import 'package:flutter_app_test/models/webinar.dart';
// import 'package:flutter_app_test/utils/settings.dart';

getWebinars(context, callback) async {
  var result = await sendPost('getwebinars', {});
  if (result['error'] == false) {
    var data = result['answer'][0];
    var state = data['state'];
    var total_count = int.parse(data['count'].toString());
    var current_page = int.parse(data['page'].toString());
    var per_page = int.parse(data['perpage'].toString());
    var current_list_data = data['list'];
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
          arrayItem["autorpic"],
          arrayItem["videohttps"]));
    });
    callback(webinars);
  } else {
    showToast(context, text: result['answer']);
  }
}

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  List _webinars = [];

  @override
  void initState() {
    getWebinars(context, setWebinars);
    super.initState();
  }

  setWebinars(webinars) {
    setState(() {
      _webinars = webinars;
    });
  }

  @override
  Widget build(BuildContext context) {
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
