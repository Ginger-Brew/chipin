import 'package:chipin/restaurant_register/RestaurantRegister.dart';
import 'package:chipin/tab_container_screen/tab_container_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'child_main/ChildMain.dart';
import 'login/login.dart';
import 'login/register.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized()는 runApp으로 앱이 실행되기 전에 비동기로 지연이 되더라도 오류가 발생하지 않도록 하는 역할.
  WidgetsFlutterBinding.ensureInitialized();

  // // Firebase.initializeApp()은 앱을 실행할 때 Firebase를 비동기 방식으로 초기화.
  // // Firebase를 쓸 때 주석 해제.
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // 화면 세로모드로 강제 고정
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CHIPIN',
        // debugShowCheckedModeBanner : 오른쪽상단 빨간색 표시
        debugShowCheckedModeBanner: false,
        routes: {
          // '/home': (context) => NavigationHomeScreen(pagename: DrawerIndex.HOME),
          '/login': (context) => LoginPage(),
          // '/splash': (context) => SplashScreen(),
          '/register': (context) => RegisterPage(),
          '/childmain' : (context) => ChildMain(),
          '/storemain' : (context) => RestaurantRegister(),
        },
        // 실행 시 가장 먼저 보여지는 화면 (splash 화면을 따로 만들거면 그 화면으로 해야함)
        initialRoute: '/login'
    );
  }
}
