import 'package:Rapdi/custom_icon_icons.dart';
import 'package:Rapdi/screens/account.dart';
import 'package:Rapdi/screens/search_rhymes.dart';
import 'package:Rapdi/screens/songs_manger.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainNavigator extends StatefulWidget {
  MainNavigator({Key key}) : super(key: key);

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  List<Widget> _navigatorList;
  int mainIndex = 0;
  int _currentIndex;
  DateTime currentBackPressTime;

  List<BottomNavigationBarItem> _bottomNavItem = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(CustomIcon.writesong_outline),
        activeIcon: Icon(CustomIcon.writesong),
        label: 'Viết Nhạc'),
    BottomNavigationBarItem(
        icon: Icon(Icons.search_outlined), label: 'Tìm Vần'),
    BottomNavigationBarItem(
        icon: Icon(CustomIcon.user_outline),
        activeIcon: Icon(CustomIcon.user),
        label: 'Tài Khoản')
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = mainIndex;

    _navigatorList = <Widget>[
      SongsManager(),
      RhymesSearcher(),
      Account(),
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
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _navigatorList,
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    // if (_currentIndex != 0) {
    //   setState(() {
    //     _currentIndex = 0;
    //   });
    //   return Future.value(false);
    // }
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Utils.showToast('Chạm lần nữa để thoát');
      return Future.value(false);
    }
    return Future.value(true);
  }
}
