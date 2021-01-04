import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/custom_icon_icons.dart';
import 'package:Rapdi/services/rhyme_services.dart';
import 'package:Rapdi/widgets/no_result_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/RhymeSearchResults.dart';

import 'package:Rapdi/widgets/search_bar/custom_search_bar.dart';
import 'package:Rapdi/widgets/search_bar/search_bar_style.dart';
import 'package:Rapdi/utils/globals.dart' as globals;

class RhymesSearcher extends StatefulWidget {
  final VoidCallback onPush;

  var search4me;

  RhymesSearcher({Key key, this.onPush, this.search4me}) : super(key: key);

  @override
  _RhymesSearcherState createState() => _RhymesSearcherState();
}

class _RhymesSearcherState extends State<RhymesSearcher> {
  // with AutomaticKeepAliveClientMixin<RhymesSearcher> {

  @override
  void initState() {
    super.initState();
    if (widget.search4me != null) _search(widget.search4me);
  }

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
          if (widget.search4me != null)
            InkWell(
              child: const Icon(
                Icons.arrow_back_outlined,
                color: AppTheme.primaryColor,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
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
      initValue: widget.search4me,
      searchBarStyle: SearchBarStyle(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        borderRadius: BorderRadius.circular(10),
      ),
      loader: Center(
        child: CircularProgressIndicator(), // Activity Indicator
      ),
      placeHolder: Center(child: placeHolder()),
      emptyWidget: _showEmpty(),
      onError: _showError,
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
  Future<List<RhymeSearchResults>> _search(String words) async {
    globals.searchedText = words;
    final results = await RhymesServices().findRhymes(words);
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

  Widget _showError(Error error) {
    return NoResultFound(
      mess: "Oops lỗi rồi!!!\nBạn vui lòng thử lại với từ khác nhé.",
      url: 'assets/images/error.svg',
    );
  }

  Widget _showEmpty() {
    return NoResultFound(
      mess: "SORRY, Không tìm thấy vần nào hết",
      url: 'assets/images/no_result.svg',
    );
  }
}
