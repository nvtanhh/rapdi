import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/services/auth.dart';
import 'package:Rapdi/services/firestore_service.dart';
import 'package:Rapdi/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<FiretoreService>()),
        StreamProvider<User>(create: (_) => AuthService().userStream()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UI Kit',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: AppTheme.primaryColor,
          // primaryColorLight: AppTheme.accent2Color,
          accentColor: AppTheme.accentColor,
          backgroundColor: Colors.white,
          primarySwatch: Colors.deepPurple,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: AppTheme.primaryColor),
            actionsIconTheme: IconThemeData(
              size: 30.0,
              color: AppTheme.primaryColor,
              opacity: 10.0,
            ),
          ),
          fontFamily: 'Roboto',
        ),
        // home: SongDemo(songId: 2)
        home: SplashScreen(),
        builder: EasyLoading.init(),
        // home: SongWriter(),
        // home: RhymesBookmark(),
      ),
    );
  }
}
