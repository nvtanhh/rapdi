import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String root = '/';
}

Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
  return {
    TabNavigatorRoutes.root: (context) => Container(),
  };
}

class FreeStyleNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  FreeStyleNavigator({this.navigatorKey});

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
