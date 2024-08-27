import 'package:ecobean_frontend/screens/login_screen.dart';
import 'package:ecobean_frontend/screens/main_screen.dart';
import 'package:ecobean_frontend/screens/mypage_screen.dart';
import 'package:ecobean_frontend/screens/onboarding_screen.dart';
import 'package:ecobean_frontend/screens/recycling_screen.dart';
import 'package:ecobean_frontend/screens/stamp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: '3nmp3igh5m',
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFCF8),
      ),
      home: MainScreen(),
    );
  }
}
