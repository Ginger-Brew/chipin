import 'package:chipin/colors.dart';
import 'package:chipin/restaurant_main/RestaurantMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'child/model/model_menu_provider.dart';
import 'child/model/model_restaurant_provider.dart';
import 'child/screen/child_main/ChildMain.dart';
import 'customer_main/ClientMain.dart';
import 'firebase_options.dart';
import 'login/login.dart';
import 'login/model/model_auth.dart';
import 'login/model/model_login.dart';
import 'login/registerdetail_over.dart';
import 'restaurant_register/RestaurantInfoRegister.dart';

class ColorService {
  //테마 컬러를 지정할 때 사용하는 classs
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

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // 백그라운드 작업 수행
    // 여기서 데이터베이스 업데이트 또는 기타 작업을 수행할 수 있습니다.
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // await updateIsValidField();
    print(
        "Native called background task: $task"); //simpleTask will be emitted here.
    // int? totalExecutions;
    // final _sharedPreference = await SharedPreferences.getInstance(); //Initialize dependency

    try {
      //add code execution
      // totalExecutions = _sharedPreference.getInt("totalExecutions");
      // _sharedPreference.setInt("totalExecutions", totalExecutions == null ? 1 : totalExecutions+1);
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await updateIsValidField();
    } catch (err) {
      Logger().e(err
          .toString()); // Logger flutter package, prints error on the debug console
      throw Exception(err);
    }

    return Future.value(true);
  });
}

Future<num> readtotalPoint(String restaurantId) async {
  num earnPoint = 0;
  num redeemPoint = 0;



    final db = FirebaseFirestore.instance
        .collection("Restaurant")
        .doc(restaurantId);

    try {
      final queryEarnSnapshot = await db.collection("EarnList").get();

      if (queryEarnSnapshot.docs.isNotEmpty) {
        for (var docSnapshot in queryEarnSnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          earnPoint += docSnapshot.data()['earnPoint'];
        }
      }
    } catch (e) {
      print("Error completing: $e");
    }

    try {
      final queryEarnSnapshot = await db.collection("RedeemList").get();

      if (queryEarnSnapshot.docs.isNotEmpty) {
        for (var docSnapshot in queryEarnSnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          redeemPoint += docSnapshot.data()['redeemPoint'];
        }
      }
    } catch (e) {
      print("Error completing: $e");
    }


  return earnPoint - redeemPoint;
}

Future<void> updateIsValidField() async {
  try {
    final firestore = FirebaseFirestore.instance;
    final discountCodeCollection = firestore.collection('DiscountCode');
    final RestaurantCollection = firestore.collection('Restaurant');
    final currentTimestamp = DateTime.now();

    // DiscountCode 콜렉션의 도큐먼트들을 가져옴
    final QuerySnapshot CodeSnapshot = await discountCodeCollection.get();

    // 도큐먼트 돌면서 도큐먼트 아이디 (할인코드), isUsed, isValid, restaurantId, reservationPrice, isWritten  가져와서 노쇼 여부 확인 후
    // isValid 업데이트 및 식당 적립 내역에 해당 내용 추가
    // 식당 적립 내역에 내용 추가 시 isWritten 필드 true로 변경
    for (QueryDocumentSnapshot documentSnapshot in CodeSnapshot.docs) {
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      final String discountCode = documentSnapshot.id;
      final DateTime expirationDate = data['expirationDate'].toDate();
      final bool isUsed = data['isUsed'];
      final String restaurantId = data['restaurantId'];
      final bool isWritten = data['isWritten'];
      final num reservationPrice = data['reservationPrice'];
      final bool isValid = isUsed
          ? true
          : (expirationDate.isAfter(currentTimestamp) ? true : false);

      // print('valid한가요? : ${isValid}');
      // isValid 값을 업데이트
      await discountCodeCollection
          .doc(discountCode)
          .update({'isValid': isValid});

      if (!isValid && !isWritten) {

        num totalPoint = await readtotalPoint(restaurantId);
        await RestaurantCollection.doc(restaurantId)
            .collection('EarnList')
            .add({
          'earnDate': DateTime.now(),
          'earnPoint': reservationPrice,
          'totalPoint': totalPoint + reservationPrice
        });

        await discountCodeCollection
            .doc(discountCode)
            .update({'isWritten': true});
      }
    }

    print('업데이트가 완료되었습니다.');
  } catch (error) {
    print('업데이트 중 오류 발생: $error');
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

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask('1', 'simpleTask',
      initialDelay: Duration(seconds: 10),
      frequency: Duration(seconds: 20) // 작업 시작 지연 시간 설정

      );
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
                primarySwatch:
                    ColorService.createMaterialColor(MyColor.DARK_YELLOW)),
            //테마 컬러를 dark_yellow로 설정함

            // debugShowCheckedModeBanner : 오른쪽상단 빨간색 표시
            debugShowCheckedModeBanner: false,
            routes: {
              // '/home': (context) => NavigationHomeScreen(pagename: DrawerIndex.HOME),
              '/login': (context) => LoginPage(),
              // '/splash': (context) => SplashScreen(),
              '/register': (context) => RegisterPage(),
              '/childmain': (context) => ChildMain(),
              '/storeregister': (context) => RestaurantInfoRegister(),
              '/storemain': (context) => RestaurantMain(),
              // '/restaurantdetail' : (context) => TabContainerScreen(),
              '/clientmain': (context) => ClientMain(),
            },
            // 실행 시 가장 먼저 보여지는 화면 (splash 화면을 따로 만들거면 그 화면으로 해야함)
            initialRoute: '/login'));
  }
}
