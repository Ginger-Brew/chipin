import 'package:chipin/colors.dart';
import 'package:chipin/restaurant_main/RestaurantMain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'child/model/model_menu_provider.dart';
import 'child/screen/child_code_generate/code_generate_screen.dart';
import 'child/screen/child_main/ChildMain.dart';
import 'customer_main/ClientMain.dart';
import 'firebase_options.dart';
import 'login/login.dart';
import 'login/model/model_auth.dart';
import 'login/model/model_login.dart';
import 'login/register.dart';
import 'child/model/model_restaurant_provider.dart';
import 'restaurant_register/RestaurantInfoRegister.dart';


class ColorService { //테마 컬러를 지정할 때 사용하는 classs
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}


void main() async {
  // WidgetsFlutterBinding.ensureInitialized()는 runApp으로 앱이 실행되기 전에 비동기로 지연이 되더라도 오류가 발생하지 않도록 하는 역할.
  WidgetsFlutterBinding.ensureInitialized();

  // 달력에서 한국어를 지원해주는 역할
  await initializeDateFormatting('ko');

  // Firebase.initializeApp()은 앱을 실행할 때 Firebase를 비동기 방식으로 초기화.
  // Firebase를 쓸 때 주석 해제.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 화면 세로모드로 강제 고정
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
          ChangeNotifierProvider(create: (_) => MenuProvider()),
          ChangeNotifierProvider(create: (_) => RestaurantProvider()),
          ChangeNotifierProvider(create: (_) => LoginModel()),
        ],
        child: MaterialApp(
            title: 'CHIPIN',
            theme: ThemeData(
                primarySwatch: ColorService.createMaterialColor(
                    MyColor.DARK_YELLOW)), //테마 컬러를 dark_yellow로 설정함

            // debugShowCheckedModeBanner : 오른쪽상단 빨간색 표시
            debugShowCheckedModeBanner: false,

            routes: {
              // '/home': (context) => NavigationHomeScreen(pagename: DrawerIndex.HOME),
              '/login': (context) => LoginPage(),
              // '/splash': (context) => SplashScreen(),
              '/register': (context) => RegisterPage(),
              '/childmain': (context) => ChildMain(),
              '/storeregister' : (context) => RestaurantInfoRegister(),
              '/storemain': (context) => RestaurantMain(),
              // '/restaurantdetail' : (context) => TabContainerScreen(),
              '/clientmain' : (context) => ClientMain(),
              '/codegenerate' : (context) => CodeGenerateScreen()
            },
            // 실행 시 가장 먼저 보여지는 화면 (splash 화면을 따로 만들거면 그 화면으로 해야함)
            initialRoute: '/login'
        ));
  }
}