import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../app_theme.dart';

class NoResultFound extends StatelessWidget {
  final String mess;

  NoResultFound({this.mess});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/no_result.svg'),
          SizedBox(height: 30),
          Text(
            mess,
            style: AppTheme.secondaryText,
          ),
        ],
      ),
    );
  }
}
