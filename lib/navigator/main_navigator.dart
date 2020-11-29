import 'package:Rapdi/custom_icon_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Rapdi/navigator/songs_navigator.dart';
import 'package:Rapdi/navigator/rhymes_searcher_navigator.dart';
import 'package:Rapdi/navigator/freestyle_navigator.dart';
import 'package:Rapdi/navigator/account_navigator.dart';

class MainNavigator extends StatefulWidget {
  MainNavigator({Key key}) : super(key: key);

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  List<Widget> _navigatorList;
  int mainIndex = 0;
  int _currentIndex;

  List<BottomNavigationBarItem> _bottomNavItem = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(CustomIcon.writesong_outline),
        activeIcon: Icon(CustomIcon.writesong),
        label: 'Viết Nhạc'),
    BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: 'Tìm Vần'),
    // BottomNavigationBarItem(
    //     icon: Icon(CustomIcon.mic_outline),
    //     activeIcon: Icon(CustomIcon.mic),
    //     label: 'Freestyle'),
    BottomNavigationBarItem(
        icon: Icon(CustomIcon.user_outline),
        activeIcon: Icon(CustomIcon.user),
        label: 'Tài Khoản')
  ];

  Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = mainIndex;

    _navigatorList = <Widget>[
      SongsNavigator(navigatorKey: _navigatorKeys[0]),
      RhymesSearcherNavigator(navigatorKey: _navigatorKeys[1]),
      AccountNavigator(navigatorKey: _navigatorKeys[2]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          // selectedItemColor: Colors.red,
          items: _bottomNavItem,
          onTap: _selectTab,
        ),
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
        ]),
      ),
    );
  }

  Widget _buildOffstageNavigator(int tabIndex) {
    return Offstage(
        offstage: _currentIndex != tabIndex, child: _navigatorList[tabIndex]);
  }

  Future<bool> _onBackPressed() async {
    final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_currentIndex].currentState.maybePop();
    if (isFirstRouteInCurrentTab) {
      // if not on the 'main' tab
      if (_currentIndex != mainIndex) {
        // select 'main' tab
        _selectTab(mainIndex);
        // back button handled by app
        return false;
      }
    }
    // let system handle back button if we're on the first route
    return isFirstRouteInCurrentTab;
  }

  _selectTab(int index) {
    if (index == _currentIndex) {
      // pop to first route
      _navigatorKeys[index].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentIndex = index);
    }
  }
}
