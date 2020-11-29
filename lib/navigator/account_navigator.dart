
import 'package:Rapdi/screens/account.dart';
import 'package:flutter/material.dart';



class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class AccountNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  AccountNavigator({this.navigatorKey});

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => Account(),
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
