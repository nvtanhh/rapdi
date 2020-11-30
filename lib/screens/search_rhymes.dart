import 'dart:convert';

import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/custom_icon_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/RhymeSearchResults.dart';

import 'package:Rapdi/widgets/search_bar/custom_search_bar.dart';
import 'package:Rapdi/widgets/search_bar/search_bar_style.dart';
import 'package:Rapdi/utils/globals.dart' as globals;

class RhymesSearcher extends StatefulWidget {
  final VoidCallback onPush;

  RhymesSearcher({Key key, this.onPush}) : super(key: key);

  @override
  _RhymesSearcherState createState() => _RhymesSearcherState();
}

class _RhymesSearcherState extends State<RhymesSearcher> {
  // with AutomaticKeepAliveClientMixin<RhymesSearcher> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: getSearchBarUI(),
            )
          ],
        ),
      ),
    );
  }

  getAppBarUI() {
    return Container(
      // color: Colors.red,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(child: Text('Tìm vần', style: AppTheme.largeTitle)),
          InkWell(
            onTap: () {
              widget.onPush();
            },
            child: Icon(CustomIcon.bookmark,
                size: 24, color: AppTheme.primaryColor),
          )
        ],
      ),
    );
  }

  getSearchBarUI() {
    return SearchBar<RhymeSearchResults>(
      searchBarStyle: SearchBarStyle(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        borderRadius: BorderRadius.circular(10),
      ),
      loader: Center(
        child: CircularProgressIndicator(), // Activity Indicator
      ),
      placeHolder: Center(child: placeHolder()),
      emptyWidget: Center(
        child: Text("Empty"),
      ),
      hintText: "Search",
      hintStyle: TextStyle(
        fontSize: 17,
        color: AppTheme.holderColor,
      ),
      textStyle: TextStyle(
        fontSize: 17,
        color: Colors.black,
      ),
      onSearch: _search,
      isRhymesSearch: true, // my custom props
    );
  }

  // get result form API
  Future<List<RhymeSearchResults>> _search(String search) async {
    globals.searchedText = search;

    String jsonStr = await rootBundle.loadString('assets/rhymeResult.json');
    List jsonResponse = jsonDecode(jsonStr);
    // print(jsonResponse.length);

    List<RhymeSearchResults> results =
        (jsonResponse).map((i) => RhymeSearchResults.fromJson(i)).toList();

    return results;
  }

  Widget placeHolder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/the_search.svg'),
        SizedBox(height: 30),
        Text(
          "Tìm vần ngay thôi!",
          style: AppTheme.secondaryText,
        ),
      ],
    );
  }
}
