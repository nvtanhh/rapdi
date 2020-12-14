import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xFF020887);
  static const Color primaryLightColor = Color(0xFFF4F5FF);
  static const Color accentColor = Color(0xFF3F0287);
  // static const Color accent2Color = Color(0xFF024A87);
  static const Color searhBarFill = Color(0xFF767680);
  static const Color textColor = Colors.black87;
  static const Color holderColor = Color(0xFF999999);
  static const Color darkRed = Color(0xFFD80000);

  static const TextStyle largeTitle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: 34,
    letterSpacing: 0.4,
    height: 0.9,
    color: primaryColor,
  );
  static const TextStyle listTitle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    letterSpacing: 0.4,
    height: 0.9,
    color: Colors.black87,
  );
  static const TextStyle appbarTitle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    fontSize: 17,
    letterSpacing: 0.4,
    height: 1.3,
    color: primaryColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 17,
    letterSpacing: 0.4,
    height: 0.9,
    color: Colors.black87,
  );


  static const TextStyle secondaryText = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 17,
    letterSpacing: 0.4,
    height: 0.9,
    color: Colors.black45,
  );
  static const TextStyle captionText = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: Colors.grey,
  );
}
