import 'package:flutter/material.dart';

class SearchBarStyle {
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const SearchBarStyle(
      {this.backgroundColor = const Color(0xFFF4F5FF),
      this.padding = const EdgeInsets.all(5.0),
      this.borderRadius: const BorderRadius.all(Radius.circular(5.0))});
}
