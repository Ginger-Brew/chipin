import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chipin/base_appbar.dart';
import 'package:flutter/services.dart';
import '../colors.dart';
import '../core/utils/size_utils.dart';
import 'RestaurantPayment.dart';

class RestaurantDiscount extends StatefulWidget {
  final String enterednumber;

  const RestaurantDiscount(this.enterednumber);

  @override
  _RestaurantDiscountState createState() => _RestaurantDiscountState();
}

class _RestaurantDiscountState extends State<RestaurantDiscount> {
  List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());
  List<FocusNode> focusNodes =
      List.generate(4, (index) => FocusNode()); // Add this line
  List<String> result = List.generate(4, (index) => '');

  //firestore에 저장할 때 사용할 컬렉션 이름과 도큐먼트 이름
  final String colName = "Restaurant";
  final String subColName = "RedeemList";
  String name = "";
  String address1 = "";
  String address2 = "";


  User? getUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Name, email address, and profile photo URL
      final name = user.displayName;
      final email = user.email;
      final photoUrl = user.photoURL;

      // Check if user's email is verified
      final emailVerified = user.emailVerified;

      // The user's ID, unique to the Firebase project. Do NOT use this value to
      // authenticate with your backend server, if you have one. Use
      // User.getIdToken() instead.
      final uid = user.uid;
    }
    return user;
  }

//할인 코드가 유효한지 확인 - 아동 db에서 할인 코드와 동일한 이름의 도큐먼트가 있는지 확인
  Future<int> isCodeValid() async {
    final db = FirebaseFirestore.instance.collection("Child").doc("child@test.com").collection("ReservationInfo");

    try {
      final querySnapshot = await db.where('reservationCode', isEqualTo: result.join()).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          print(docSnapshot.data()['reservationPrice']);
          return docSnapshot.data()['reservationPrice'];
        }
      }
    } catch (e) {
      print("Error completing: $e");
    }

    return -1;
  }


  // 화면 상단에 식당 정보를 표기하기 위해 필요 - 식당 db에서 식당 정보 가져오기
  void readRestaurantData() async {
    User? currentUser = getUser();

    if(currentUser != null) {
      final db = FirebaseFirestore.instance.collection(colName).doc(currentUser.email);

      await db.get().then((DocumentSnapshot ds) {
        Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

          name = data['name'];
          address1 = data['address1'];
          address2 = data['address2'];
        });

    }
  }

// 식당 db에 차감 내역을 작성하기 위해 필요 - 이전 페이지에서 전달받은 값과 아동 db에서 가져온 예약 금액을 가져와서 비교 후 저장
  void writeRedeemData(int redeemPoint, int payment, DateTime redeemDate, num totalPoint) async {
    User? currentUser = getUser();

    if (currentUser != null) {
      final db = FirebaseFirestore.instance
          .collection("Restaurant")
          .doc(currentUser.email)
          .collection("RedeemList")
          .doc(result.join());

      // firestore에 저장
      await db
          .set({
        'redeemPoint': redeemPoint,
        'redeemDate': redeemDate,
        'totalPoint': totalPoint - redeemPoint
      })
          .then((value) => print("document added")) // firestore에 저장이 잘 된 경우
          .catchError((error) => print("Fail to add doc ${error}"));

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RestaurantPayment(payment)));
    }else {

    }
  }
// 식당 db에 차감 내역을 작성할 때 표기할 전체 포인트를 구하기 위해 필요 - earnlist의 값의 합에서 redeemlist의 값의 합을 뺌
  Future<num> readtotalPoint() async {

    num earnPoint = 0;
    num redeemPoint = 0;

    User? currentUser = getUser();

    if(currentUser != null) {
      final db = FirebaseFirestore.instance.collection("Restaurant").doc(
          currentUser.email);

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
    }

  return earnPoint-redeemPoint;
      }
  @override
  void initState() {
    super.initState();
    // Add listeners to each controller
    readRestaurantData();
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.length == 1) {
          result[i] = controllers[i].text;
          if (i < controllers.length - 1) {
            FocusScope.of(context)
                .requestFocus(focusNodes[i + 1]); // Change this line
          } else {
            // Reached the last field, do something
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      // Add this loop
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> textFields = controllers.asMap().entries.map((entry) {
      int index = entry.key;
      TextEditingController controller = entry.value;
      FocusNode focusNode =
          focusNodes[index]; // Get the corresponding focus node

      return Container(
        margin: EdgeInsets.all(10.0),
        width: 50.0,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          // Assign the focus node
          maxLength: 1,
          buildCounter: (BuildContext context,
                  {int? currentLength, int? maxLength, bool? isFocused}) =>
              null,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.text,
          decoration:
              InputDecoration(border: OutlineInputBorder(), isDense: true),
          textInputAction: index == controllers.length - 1
              ? TextInputAction.done // Set Done for the last text field
              : TextInputAction.next,
          // Set Next for the rest of the fields
          onSubmitted: (value) {
            if (index < controllers.length - 1) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            } else {
              // Reached the last field, do something
            }
          },
        ),
      );
    }).toList();
    readRestaurantData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BaseAppBar(title: "가게정보"),
      body: Container(
          width: mediaQueryData.size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 27, 22, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: getPadding(left: 1),
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: "Mainfonts",
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.black,
                                  size: 19,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text(
                                    address1 + " " + address2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  '할인 코드를 입력해주세요',
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      color: Colors.grey,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: textFields,
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    int reservationPrice = await isCodeValid();
                    int redeemPoint = reservationPrice > int.parse(widget.enterednumber) ? int.parse(widget.enterednumber) : reservationPrice;
                    int payment = reservationPrice > int.parse(widget.enterednumber) ? 0 : int.parse(widget.enterednumber) - reservationPrice;
                    DateTime redeemDate = DateTime.now();
                    num totalPoint = await readtotalPoint();
                    // debugPrint("debug : ${reservationPrice}");
                    // debugPrint("debug : ${redeemPoint}");
                    // debugPrint("debug : ${payment}");
                    // Call the async function and await the result
                    if (reservationPrice != -1) {
                      writeRedeemData(redeemPoint, payment, redeemDate, totalPoint);
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('유효하지 않은 할인 코드입니다')));
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(MyColor.DARK_YELLOW),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      // side: BorderSide(color: Colors.red)
                    )),
                    fixedSize: MaterialStateProperty.all<Size>(
                      Size(MediaQuery.of(context).size.width - 32,
                          48), // 가로 길이를 화면 가로 길이 - 32로 설정
                    ),
                  ),
                  child: const Text(
                    "확인",
                    style: TextStyle(
                        fontFamily: "Mainfonts",
                        color: Colors.white,
                        fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
