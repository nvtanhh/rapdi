import 'package:flutter/material.dart';

import 'package:Rapdi/models/Song.dart';
import 'package:Rapdi/screens/songs_manger.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class SongsNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  SongsNavigator({this.navigatorKey});

  void _push(BuildContext context, {Song song}) {
    var routeBuilders = _routeBuilders(context, song: song);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[TabNavigatorRoutes.detail](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, {Song song}) {
    return {
      TabNavigatorRoutes.root: (context) => new SongsManager(
          // onPush: (Song song) => _push(context, song: song),  // onPush called with a song object
          ),
      // TabNavigatorRoutes.detail: (context) => SongWriter(song: song),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }
}
