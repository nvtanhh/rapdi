import 'package:flutter/material.dart';

class FreeStyle extends StatefulWidget {
  FreeStyle({Key key}) : super(key: key);

  @override
  _FreeStyleState createState() => _FreeStyleState();
}

class _FreeStyleState extends State<FreeStyle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('FreeStyle')),
    );
  }
}
