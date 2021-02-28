import 'package:Rapdi/screens/rhymes_bookmark.dart';
import 'package:Rapdi/screens/search_rhymes.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String bookmark = '/bookmark';
}

class RhymesSearcherNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  RhymesSearcherNavigator({this.navigatorKey});

  void _push(
    BuildContext context,
  ) {
    var routeBuilders = _routeBuilders(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.bookmark](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => RhymesSearcher(
          // onPush: () => _push(context),
          ),
      TabNavigatorRoutes.bookmark: (context) => RhymesBookmark(),
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
