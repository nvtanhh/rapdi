import 'dart:io';

import 'package:Rapdi/services/auth.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlatButton(
          onPressed: () async {
            _signOut();
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }

  void _signOut() async {
    Utils.onLoading();
    await Future.delayed(Duration(milliseconds: 500), AuthService().signOut);
    await EasyLoading.dismiss();
  }
}
