
import 'package:Rapdi/navigator/main_navigator.dart';
import 'package:Rapdi/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return LoginScreen();
    } else {
      return MainNavigator();
    }
  }
}