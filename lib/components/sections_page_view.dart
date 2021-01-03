import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/settings.dart';

import 'my_icon_button.dart';

class sections_page_view extends StatefulWidget {
  const sections_page_view(
      {Key key, @required Function callback, @required List sections})
      : _callback = callback,
        _sections = sections,
        super(key: key);
  final Function _callback;
  final List _sections;

  @override
  _sections_page_viewState createState() =>
      _sections_page_viewState(_callback, _sections);
}

class _sections_page_viewState extends State<sections_page_view> {
  _sections_page_viewState(Function callback, List sections)
      : _callback = callback,
        _sections = sections;
  final Function _callback;
  final List _sections;

  int _position = 0;
  PageController _sectionController;

  @override
  void initState() {
    setSections(_sections);
    _sectionController = PageController(initialPage: 0, keepPage: true);
    super.initState();
  }

  setSections(sections) {
    setState(() {
      _callback(sections[_position].sectionid);
    });
  }

  setCurrentSectionId(itemid) {
    setState(() {
      _position = itemid;
      _callback(_sections[_position].sectionid);
    });
  }

  _goToPreviousSection([forColor = false]) {
    if (forColor) {
      if (_position == 0)
        return null;
      else
        return true;
    }
    _sectionController.animateToPage(_position - 1,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  _goToNextSection([forColor = false]) {
    if (forColor) {
      if (_position + 1 == _sections.length)
        return null;
      else
        return true;
    }
    _sectionController.animateToPage(_position + 1,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    // double c_width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(children: [
            MyIconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: (_goToPreviousSection(true) == null)
                      ? unAvailableColor
                      : mainColor,
                  size: 18,
                ),
                callback: (_goToPreviousSection(true) == null)
                    ? null
                    : _goToPreviousSection),
            Expanded(
              child: PageView.builder(
                controller: _sectionController,
                onPageChanged: setCurrentSectionId,
                itemCount: _sections.length,
                itemBuilder: (context, position) {
                  return SectionItem(sections: _sections, position: position);
                },
              ),
            ),
            MyIconButton(
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: (_goToNextSection(true) == null)
                      ? unAvailableColor
                      : mainColor,
                  size: 18,
                ),
                callback: (_goToNextSection(true) == null)
                    ? null
                    : _goToNextSection),
          ]),
          height: 100,
        ),
        Text((_position + 1).toString() + '/' + _sections.length.toString())
      ]),
    );
  }
}

class SectionItem extends StatelessWidget {
  const SectionItem({Key key, @required List sections, @required int position})
      : _sections = sections,
        _position = position,
        super(key: key);
  final int _position;
  final List _sections;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Icon(
                Icons.school,
                color: Theme.of(context).accentColor,
                size: 24,
              )),
          Expanded(
            child: Text(
              _sections[_position].name,
              style: TextStyle(
                  color: secondColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(7)),
    );
  }
}
