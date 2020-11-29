import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:Rapdi/widgets/silver_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RhymesBookmark extends StatefulWidget {
  RhymesBookmark({Key key}) : super(key: key);

  @override
  _RhymesBookmarkState createState() => _RhymesBookmarkState();
}

class _RhymesBookmarkState extends State<RhymesBookmark> {
  List bookmarks = [
    "tình duyên - chính trị viên",
    "tình duyên - tỉnh uỷ viên",
    "tình duyên - tính chuyện",
    "tình duyên - chính diện",
    "tình duyên - chính điện",
    "tình duyên - bình điện",
    "tình duyên - chinh chiến",
    "tình duyên - sinh tiền",
    "tình duyên - tính chuyện",
    "tình duyên - chính diện",
    "tình duyên - chính điện",
    "tình duyên - bình điện",
    "tình duyên - chính diện",
    "tình duyên - chính điện",
    "tình duyên - bình điện",
    "tình duyên - chinh chiến",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        // padding: EdgeInsets.only(top: 10),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 100,
              toolbarHeight: 56,
              elevation: 50,
              pinned: true,
              floating: true,
              centerTitle: true,
              backgroundColor: Colors.white,
              flexibleSpace: CustomSilverAppbar(
                title: 'Bookmark vần',
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: AppTheme.primaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverFixedExtentList(
                itemExtent: 48,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) =>
                      _bookmarkItem(context, index),
                  childCount: bookmarks.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bookmarkItem(BuildContext context, int index) {
    return Container(
      // alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            bookmarks[index].toString(),
            style: AppTheme.bodyText,
          ),
          GestureDetector(
            onTap: () {
              showAlertDialogDelete(context, index);
            },
            child: Icon(
              Icons.remove_circle_outline_rounded,
              color: AppTheme.darkRed,
            ),
          )
        ],
      ),
    );
  }

  removeBookmark(int index) {
    setState(() {
      bookmarks.removeAt(index);
    });
  }

  showAlertDialogDelete(BuildContext context, int index) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Huỷ", style: TextStyle(color: Colors.grey)),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Xoá",
        style: TextStyle(color: AppTheme.accentColor),
      ),
      onPressed: () {
        // Navigator.of(context).pop(); // not work
        Navigator.of(context, rootNavigator: true).pop('dialog');
        removeBookmark(index);
        Utils.showToast('Đã xoá');
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Bạn có chắc muốn xoá cặp vần này?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}




