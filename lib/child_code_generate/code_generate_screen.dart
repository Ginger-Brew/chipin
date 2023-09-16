import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../base_appbar.dart';
import '../../colors.dart';
import '../../core/utils/size_utils.dart';

class CodeGenerateScreen extends StatefulWidget {
  const CodeGenerateScreen({super.key});

  @override
  _CodeGenerateScreenState createState() => _CodeGenerateScreenState();
}

class _CodeGenerateScreenState extends State<CodeGenerateScreen> {
  final String colName = "Child";
  final String email = "child@test.com";
  final String reservation = "ReservationInfo";
  final String RestaurantID = "aaaa";
  String reservationCode = "0000";
  String reservationDate = "";
  int reservationPrice = 0;
  String cancellationDate = "1";

  String restaurantID = "ohyang";
  String reservationDeadline = " ";


  void readData() async {
    final db = FirebaseFirestore.instance
        .collection(colName)
        .doc(email)
        .collection(reservation)
        .doc(RestaurantID);
    db.get().then((DocumentSnapshot ds) {
      Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
      setState(() {
        // cancellationDate = data[cancellationDate];
        reservationCode = data["reservationCode"];
        // reservationDate = DateFormat('yy/MM/dd').format(data["reservationDate"]);
        // reservationDate = DateFormat('yy/MM/dd').format(DateTime.now());
        Timestamp t = data["reservationDate"];
        DateTime date = t.toDate();
        reservationDate = DateFormat('yy/MM/dd HH:mm:ss').format(date);

        reservationDeadline = DateFormat('yy/MM/dd HH:mm:ss').format(date.add(const Duration(hours: 1)));
        reservationPrice = data["reservationPrice"];
      });
    });
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
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/ohyang_restaurant.png'),
                              fit: BoxFit.cover,
                            ),
                            // borderRadius: BorderRadius.circular(61),
                          ),
                          margin: const EdgeInsets.only(left: 21),
                        ),
                        Padding(
                          padding: getPadding(
                            left: 15,
                            top: 24,
                            bottom: 25,
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
                                child: const Text(
                                  "오양칼국수",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Mainfonts",
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 200, // 원하는 너비 설정
                                child: Text(
                                  "충청남도 보령시 오천면 소성리 691-52",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 14),
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
                                      "예약 마감 시간 : $reservationDeadline",
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
