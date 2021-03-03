import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../app_theme.dart';

class CustomSilverAppbar extends StatelessWidget {
  final String title;

  const CustomSilverAppbar({Key key, this.title = "Title"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0) as double;
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return SafeArea(
          child: Stack(
            children: [
              Center(
                child: Opacity(
                    opacity: 1 - opacity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            this.title,
                            style: AppTheme.appbarTitle,
                          ),
                        )
                      ],
                    )),
              ),
              Opacity(
                opacity: opacity,
                child: Column(
                  // alignment: Alignment.centerLeft,
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      height: 70,
                      padding: const EdgeInsets.only(left: 18),
                      alignment: Alignment.centerLeft,
                      child: Text(this.title, style: AppTheme.largeTitle),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getImage() {
    return Container(
      width: double.infinity,
      child: Image.network(
        'https://source.unsplash.com/daily?code',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget getTitle(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 26.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
