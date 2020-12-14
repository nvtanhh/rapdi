import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoResultFound extends StatelessWidget {
  final String mess;
  final String url;

  NoResultFound({this.mess, this.url = 'assets/images/no_result.svg'});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              url,
              width: size.width * 0.5,
            ),
            SizedBox(height: 30),
            Text(
              mess,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
