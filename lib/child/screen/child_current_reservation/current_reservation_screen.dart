import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/size_utils.dart';
import '../child_appbar/ChildAppBar.dart';
import '../child_appbar/ChildDrawerMenu.dart';

class CurrentReservationScreen extends StatefulWidget {
  const CurrentReservationScreen({Key? key}) : super(key: key);

  @override
  _CurrentReservationScreenState createState() => _CurrentReservationScreenState();
}

class _CurrentReservationScreenState extends State<CurrentReservationScreen> {
  bool isLoading = true;
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

  Future<void> readData() async {
    final db = FirebaseFirestore.instance
        .collection(colName)
        .doc(user?.email)
        .collection(reservation);
    Timestamp currentTimestamp = Timestamp.now();
    DocumentSnapshot? ds;
    await db.where('expirationDate', isGreaterThan: currentTimestamp).get().then(
            (querySnapshot) {
              for (var docSnapshot in querySnapshot.docs) {
                print(docSnapshot['isUsed']);
                if (docSnapshot['isUsed'] == false) {
                   ds = docSnapshot;
                }
              }
            }
        );
    Map<String, dynamic> data = ds?.data() as Map<String, dynamic>;
    setState(() {
      isLoading = false;
      reservationCode = data["reservationCode"];
      Timestamp t = data["reservationDate"];
      DateTime date = t.toDate();
      reservationDate = DateFormat('yy/MM/dd HH:mm:ss').format(date);
      Timestamp eT = data["expirationDate"];
      DateTime eDate = eT.toDate();
      expirationDate = DateFormat('yy/MM/dd HH:mm:ss').format(eDate);
      reservationPrice = data["reservationPrice"];
      restaurantEmail = data["restaurantId"];
      fetchRestaurantData();
    });
    //print("씨!!!!!!!!! $querySnapshot");
    // if (querySnapshot.docs.isNotEmpty) {
    //   DocumentSnapshot ds = querySnapshot.docs.first;
    //   Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
    //   setState(() {
    //     isLoading = false;
    //     reservationCode = data["reservationCode"];
    //     Timestamp t = data["reservationDate"];
    //     DateTime date = t.toDate();
    //     reservationDate = DateFormat('yy/MM/dd HH:mm:ss').format(date);
    //     Timestamp eT = data["expirationDate"];
    //     DateTime eDate = eT.toDate();
    //     expirationDate = DateFormat('yy/MM/dd HH:mm:ss').format(eDate);
    //     reservationPrice = data["reservationPrice"];
    //     restaurantEmail = data["restaurantId"];
    //     fetchRestaurantData();
    //   });
    // }
  }

  void fetchRestaurantData() async {
    try {
      final restaurantCollection =
          FirebaseFirestore.instance.collection("Restaurant");

      QuerySnapshot restaurantQuery = await restaurantCollection.get();

      if (restaurantQuery.docs.isNotEmpty) {
        // Assuming there's only one matching document (or you can iterate through multiple if needed)
        DocumentSnapshot restaurantDoc = restaurantQuery.docs.first;
        Map<String, dynamic> restaurantData =
            restaurantDoc.data() as Map<String, dynamic>;

        // Extract the address1 and banner fields
        address1 = restaurantData["address1"];
        banner = restaurantData["banner"];
        restaurantName = restaurantData["name"];
        setState(() {
          isLoading = false; // 로딩이 끝났음을 표시
        });
      } else {
        print("No matching restaurant found.");
      }
    } catch (e) {
      print("Error fetching restaurant data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: const ChildAppBar(title: "가게정보"),
        endDrawer: const ChildDrawerMenu(),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
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
                            children: [
                              Container(
                                width: 122,
                                height: 122,
                                margin: const EdgeInsets.only(left: 21),
                                child: Image.network(
                                  banner,
                                  fit: BoxFit.cover,
                                ),
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
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Mainfonts",
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Text(
                                        address1,
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(fontSize: 14),
                                        maxLines: 3,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildCodeBox(reservationCode[0]),
                                const SizedBox(width: 10),
                                _buildCodeBox(reservationCode[1]),
                                const SizedBox(width: 10),
                                _buildCodeBox(reservationCode[2]),
                                const SizedBox(width: 10),
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
        ),
      ),
    );
  }
}
