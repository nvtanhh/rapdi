import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/custom_icon_icons.dart';
import 'package:Rapdi/models/Rhyme.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RhymesWrapper extends StatefulWidget {
  final List<Rhyme> rhymes;
  bool isVisible;

  RhymesWrapper({
    Key key,
    @required this.rhymes,
    this.isVisible = false,
  });

  @override
  _RhymesWrapperState createState() => _RhymesWrapperState();
}

class _RhymesWrapperState extends State<RhymesWrapper>
    with AutomaticKeepAliveClientMixin {
  bool _isVisible;
  int _present = 0;
  int _perPage = 15;
  int _syllableNum;

  // ScrollController _controller;
  var items = List<Rhyme>();

  @override
  void initState() {
    super.initState();
    if (widget.rhymes.length != 0) {
      _syllableNum = widget.rhymes[0].value.split(' ').length;

      _isVisible = widget.isVisible;
      _perPage =
          _perPage > widget.rhymes.length ? widget.rhymes.length : _perPage;
      setState(() {
        items.addAll(widget.rhymes.getRange(_present, _present + _perPage));
        _present = _present + _perPage;
      });

      if (_present >= widget.rhymes.length) _present += 1;
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (widget.rhymes.length == 0) return Container();
    return Container(
      child: _isVisible
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    InkWell(
                      onTap: _showListToggle,
                      child: new Container(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.expand_more,
                              size: 28,
                            ), // icon rectangle animation
                            SizedBox(
                                width: 5), // space between  the icon and tile
                            Text((_syllableNum.toString() + ' âm tiết'),
                                style: AppTheme.listTitle)
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    // itemCount: widget.rhymes.length,
                    itemCount: (_present <= widget.rhymes.length)
                        ? items.length + 1
                        : items.length,
                    itemBuilder: (context, index) {
                      return (index == items.length)
                          ? loadMoreButton()
                          : _rhymeListItem(rhyme: items[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: AppTheme.holderColor.withOpacity(.5),
                      height: 5,
                    ),
                  ),
                )
              ],
            )
          : Row(
              children: [
                InkWell(
                  onTap: _showListToggle,
                  child: new Container(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chevron_right,
                          size: 28,
                        ), // icon rectangle animation
                        SizedBox(width: 5), // space between  the icon and tile
                        Text((_syllableNum.toString() + ' âm tiết'),
                            style: AppTheme.listTitle)
                      ],
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
    );
  }

  _showListToggle() {
    print('tap....');
    // initState();
    setState(() {
      _isVisible = !_isVisible;
    });
    if (!_isVisible) {
      // reset
      _present = 15;
      _perPage = 15;
      items = items.sublist(0, 15);
    }
    print('set state done....');
  }

  Widget _rhymeListItem({Rhyme rhyme}) {
    return Container(
      height: 48,
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(child: Text(rhyme.value, style: AppTheme.bodyText)),
                InkWell(
                  onTap: () {
                    // clickInfor(rhyme.value);
                    Utils.showToast('Chức năng từ điển sẽ sớm có');
                  },
                  child: Icon(Icons.info_outline_rounded,
                      size: 28, color: AppTheme.primaryColor),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Utils.showToast('Chức năng thêm bookmark sẽ sớm có');
                    // onAddBookmark(rhyme.value);
                  },
                  child: Icon(CustomIcon.bookmark_outline,
                      size: 24, color: AppTheme.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadMore() {
    setState(() {
      if ((_present + _perPage) > widget.rhymes.length) {
        items.addAll(widget.rhymes.getRange(_present, widget.rhymes.length));
      } else {
        items.addAll(widget.rhymes.getRange(_present, _present + _perPage));
      }
      _present = _present + _perPage;
    });
  }

  Widget loadMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: _loadMore,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text(
                "Xem thêm",
                style: TextStyle(
                    fontSize: 15, color: AppTheme.primaryColor.withOpacity(.7)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

void clickInfor(String value) {}

void onAddBookmark(String matchedRhyme) {
  Utils.showToast('Đã thêm vào bookmark');
}
