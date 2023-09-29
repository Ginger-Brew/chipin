import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../base_appbar.dart';
import '../../../core/utils/size_utils.dart';


class CodeGenerateScreen extends StatefulWidget {
  const CodeGenerateScreen({super.key});

  @override
  _CodeGenerateScreenState createState() => _CodeGenerateScreenState();
}

class _CodeGenerateScreenState extends State<CodeGenerateScreen> {
  final String colName = "Child";
  User? user = FirebaseAuth.instance.currentUser;
  final String reservation = "ReservationInfo";
  final String restaurantID = "a";
  String reservationCode = "0000";
  String reservationDate = "";
  String expirationDate = "";
  int reservationPrice = 0;

  String restaurantEmail = "";
  String reservationDeadline = " ";
  String address1 = "";
  String banner = "";
  String restaurantName = "";
  User? getUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final name = user.displayName;
      final email = user.email;
      final photoUrl = user.photoURL;
      final emailVerified = user.emailVerified;
      final uid = user.uid;
    }
    return user;
  }
  void readData() async {
    final db = FirebaseFirestore.instance
        .collection(colName)
        .doc(user?.email)
        .collection(reservation);
    Timestamp currentTimestamp = Timestamp.now();
    
    QuerySnapshot querySnapshot = await db.where('expirationDate', isGreaterThan: currentTimestamp).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot ds = querySnapshot.docs.first;
      Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
      setState(() {
        reservationCode = data["reservationCode"];
        Timestamp t = data["reservationDate"];
        DateTime date = t.toDate();
        reservationDate = DateFormat('yy/MM/dd HH:mm:ss').format(date);
        Timestamp e_t = data["expirationDate"];
        DateTime e_date = e_t.toDate();
        expirationDate =DateFormat('yy/MM/dd HH:mm:ss').format(e_date);

        reservationPrice = data["reservationPrice"];
        restaurantEmail = data["restaurantId"];
        fetchRestaurantData();
      });
    }
  }
  void fetchRestaurantData() async {
    try {
      final restaurantCollection = FirebaseFirestore.instance.collection("Restaurant");

      QuerySnapshot restaurantQuery = await restaurantCollection.get();

      if (restaurantQuery.docs.isNotEmpty) {
        // Assuming there's only one matching document (or you can iterate through multiple if needed)
        DocumentSnapshot restaurantDoc = restaurantQuery.docs.first;
        Map<String, dynamic> restaurantData = restaurantDoc.data() as Map<String, dynamic>;

        // Extract the address1 and banner fields
        address1 = restaurantData["address1"];
        banner = restaurantData["banner"];
        restaurantName = restaurantData["name"];
        setState(() {
          // Set the values in the state
          // address1State = address1;
          // bannerState = banner;
        });
      } else {
        print("No matching restaurant found.");
      }
    } catch (e) {
      print("Error fetching restaurant data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    readData();

    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: const BaseAppBar(title: "가게정보"),
        body: SizedBox(
          height: mediaQueryData.size.height,
          width: double.maxFinite,
          child: Container(
            padding: getPadding(
              left: 14,
              right: 14,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: getPadding(left: 2, right: 11, top: 20),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 122,
                          height: 122,
                          margin: const EdgeInsets.only(left: 21),
                        child: Image.network(banner,
                          fit: BoxFit.cover,),
                        ),
                        Padding(
                          padding: getPadding(
                            left: 26,
                            top: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "현재 예약중!",

                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Mainfonts",
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  top: 6,
                                ),
                                child: Text(
                                  restaurantName,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Mainfonts",
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 200, // 원하는 너비 설정
                                child: Text(
                                  address1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 3, // 한 줄에 표시하고 자동으로 줄바꿈
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(
                    top: 24,
                  ),
                  child: Divider(
                    height: getVerticalSize(
                      1,
                    ),
                    thickness: getVerticalSize(
                      1,
                    ),
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: getMargin(
                    left: 21,
                    top: 24,
                    right: 21,
                  ),
                  padding: getPadding(
                    left: 14,
                    right: 14,
                    top: 14,
                    bottom: 14,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // color:  Color(0XFFB3BFCB).withOpacity(0.46)
                      color: const Color(0xFFB3BFCB).withOpacity(0.46)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: getPadding(
                          left: 1,
                          top: 1,
                          bottom: 3,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                Padding(
                                  padding: getPadding(
                                    left: 7,
                                    top: 3,
                                    bottom: 1,
                                  ),
                                  child: Text(
                                    "예약 포인트 $reservationPrice원",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    // style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: getPadding(
                                left: 3,
                                top: 11,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_filled_rounded,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      left: 9,
                                      top: 1,
                                    ),
                                    child: Text(
                                      "예약 확정 시간 : $reservationDate",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      // style: theme.textTheme.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 3,
                                top: 11,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_filled_rounded,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      left: 9,
                                      top: 1,
                                    ),
                                    child: Text(
                                      "예약 마감 시간 : $expirationDate",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      // style: theme.textTheme.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: getPadding(
                    top: 14,
                    bottom: 14,
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                        children: [
                          _buildCodeBox(reservationCode[0]),
                          const SizedBox(width: 10), // 10 픽셀의 간격
                          _buildCodeBox(reservationCode[1]),
                          const SizedBox(width: 10), // 10 픽셀의 간격
                          _buildCodeBox(reservationCode[2]),
                          const SizedBox(width: 10), // 10 픽셀의 간격
                          _buildCodeBox(reservationCode[3]),
                        ],
                      ),
                    ),
                  ),
                ),
                const Text(
                  "코드를 매장 직원에게 보여주세요",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  // style:
                  // CustomTextStyles.titleLargeGyeonggiTitleB,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeBox(String code) {
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontSize: 20,
          // fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}

EdgeInsets getPadding(
    {double? left, double? top, double? right, double? bottom}) {
  return EdgeInsets.fromLTRB(left ?? 0, top ?? 0, right ?? 0, bottom ?? 0);
}

double getHorizontalSize(double size) {
  // Replace this with your size calculation logic
  return size;
}
