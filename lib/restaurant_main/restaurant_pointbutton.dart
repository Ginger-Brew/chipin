import 'package:chipin/core/utils/size_utils.dart';
import 'package:chipin/restaurant_point_list/RestaurantEarnList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';
import 'package:chipin/base_shadow.dart';

class PointButton extends StatefulWidget {
  const PointButton({Key? key}) : super(key: key);

  @override
  State<PointButton> createState() => _PointButtonState();
}

class _PointButtonState extends State<PointButton> {

  Future<num> readRemainingPoint() async {
    num earnPoint = 0;
    num redeemPoint = 0;

    final db =
    FirebaseFirestore.instance.collection("Restaurant").doc("jdh33114");

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color : Colors.black.withOpacity(0.15),
                blurRadius: 10,
                spreadRadius: 0.0,
                offset: const Offset(0,7)

            )
          ]
      ),
      child:  ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                foregroundColor: MyColor.HOVER),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RestaurantEarnList()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "가게 잔여 포인트",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "Mainfonts"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.asset('assets/images/coins.png'),
                    ),
                    SizedBox(height: 8),
                    // Expanded(
                    //     // flex: 4,
                    //     child: FutureBuilder<num>(
                    //         future: readRemainingPoint(),
                    //         builder: (context, snapshot) {
                    //           if (snapshot.connectionState ==
                    //               ConnectionState.waiting) {
                    //             return Center(
                    //                 child: Container(
                    //                     width: (mediaQueryData.size.width - 43) / 10,
                    //                     height: (mediaQueryData.size.width - 43) / 10,
                    //                     child:
                    //                     CircularProgressIndicator())); // You can replace this with your loading screen widget.
                    //           } else if (snapshot.hasError) {
                    //             // If there's an error, show an error screen or messag
                    //             return Text('Error: ${snapshot.error}');
                    //           } else {
                    //             final remainingPoint = snapshot.data;
                    //             return Align(
                    //               alignment: Alignment.centerRight,
                    //               child: Text(
                    //                 '$remainingPoint',
                    //                 style: TextStyle(
                    //                   fontSize: 17,
                    //                   color: Colors.black,
                    //                   fontFamily: "Mainfonts",
                    //                 ),
                    //               ),
                    //             );
                    //           }
                    //         }))
                    Expanded(
                        child: FutureBuilder<num>(
                            future: readRemainingPoint(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Container(
                                        width: (mediaQueryData.size.width - 43) / 10,
                                        height: (mediaQueryData.size.width - 43) / 10,
                                        child:
                                        CircularProgressIndicator())); // You can replace this with your loading screen widget.
                              } else if (snapshot.hasError) {
                                // If there's an error, show an error screen or messag
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final remainingPoint = snapshot.data;
                                return Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '$remainingPoint',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontFamily: "Mainfonts",
                                    ),
                                  ),
                                );
                              }
                            })
                    )
                  ],
                ),
              ],
            )));
  }
}
