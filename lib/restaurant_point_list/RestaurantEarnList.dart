import 'dart:ffi';
import 'dart:math';
import 'package:chipin/base_appbar.dart';
import 'package:chipin/colors.dart';
import 'package:chipin/core/utils/size_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chipin/restaurant_point_list/restaurant_point_header.dart';

class RestaurantEarnList extends StatefulWidget {
  const RestaurantEarnList({Key? key}) : super(key: key);

  @override
  State<RestaurantEarnList> createState() => _RestaurantEarnListState();
}

class _RestaurantEarnListState extends State<RestaurantEarnList> {
  var _earnbuttoncolor = MyColor.DARK_YELLOW;
  var _redeembuttoncolor = MyColor.LIGHT_GRAY;
  bool showList1 = true;
  bool showList2 = false;


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

  void _toggleList1() {
    setState(() {
      showList1 = !showList1;
      showList2 = false;
      _earnbuttoncolor = MyColor.DARK_YELLOW;
      _redeembuttoncolor = MyColor.LIGHT_GRAY;
    });
  }

  void _toggleList2() {
    setState(() {
      showList2 = !showList2;
      showList1 = false;
      _redeembuttoncolor = MyColor.DARK_YELLOW;
      _earnbuttoncolor = MyColor.LIGHT_GRAY;
    });
  }

  Future<num> readTotalChild() async {
    num totalChild = 0;
    User? currentUser = getUser();

    if(currentUser != null) {
      final db = FirebaseFirestore.instance
          .collection("Restaurant")
          .doc(currentUser.email)
          .collection("RedeemList");

      try {
        final query = await db.count().get();
        totalChild = query.count;
      } catch (e) {
        print("Error completing: $e");
      }
    }
    else {

    }
    return totalChild;
  }

  Future<num> readAccumulationPoint() async {
    num accumulationPoint = 0;
    User? currentUser = getUser();

    if(currentUser != null) {
      final db =
      FirebaseFirestore.instance.collection("Restaurant").doc(currentUser.email);

      try {
        final queryEarnSnapshot = await db.collection("RedeemList").get();

        if (queryEarnSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in queryEarnSnapshot.docs) {
            print('${docSnapshot.id} => ${docSnapshot.data()}');
            accumulationPoint += docSnapshot.data()['redeemPoint'];
          }
        }
      } catch (e) {
        print("Error completing: $e");
      }
    }else {

    }
    return accumulationPoint;
  }

    Future<num> readRemainingPoint() async {
    num earnPoint = 0;
    num redeemPoint = 0;
    User? currentUser = getUser();

    if(currentUser!=null) {
      final db =
      FirebaseFirestore.instance.collection("Restaurant").doc(currentUser.email);

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
    }else {

    }
    return earnPoint - redeemPoint;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "우리 가게 포인트",
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 43),
              child: Row(
                children: [
                  Expanded(
                      child: FutureBuilder<num>(
                          future: readAccumulationPoint(),
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
                              // If there's an error, show an error screen or message
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final totalPoint = snapshot.data;
                              return PointHeader(
                                title: "누적 후원 포인트",
                                text: '$totalPoint',
                                icon: Image.asset(
                                    'assets/images/coins_black.png'),
                              );
                            }
                          })),
                  Expanded(
                    child: FutureBuilder<num>(
                        future: readTotalChild(),
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
                            // If there's an error, show an error screen or message
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final totalChild = snapshot.data;
                            return PointHeader(
                              title: "누적 후원 아동 수",
                              text: '$totalChild',
                              icon: Icon(Icons.people_alt_rounded),
                            );
                          }
                        })
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 34),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 47.0),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '가게 잔여 포인트',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontFamily: "Pretendard",
                        ),
                      ),
                    ),
                  ),
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
            ),
            SizedBox(height: 30),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 65),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                  onPressed: _toggleList1,
                                  child: Text(
                                    "적립 내역",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      backgroundColor: _earnbuttoncolor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ))))),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                  onPressed: _toggleList2,
                                  child: Text(
                                    "차감 내역",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black45),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      backgroundColor: _redeembuttoncolor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      )))))
                    ],
                  ),
                )),
            SizedBox(
              height: 22,
            ),
            if (showList1) Expanded(child: _buildList1()),
            if (showList2) Expanded(child: _buildList2()),
          ],
        ),
      ),
    );
  }

  Widget _buildList1() {

    User? currentUser = getUser();

    if(currentUser != null) {
      final db = FirebaseFirestore.instance;
      // Replace this with your first list widget implementation
      return StreamBuilder<QuerySnapshot>(
          stream: db
              .collection("Restaurant")
              .doc(currentUser.email)
              .collection("EarnList")
              .orderBy("earnDate", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("적립 내역이 존재하지 않습니다"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              // While the data is being fetched, show a loading indicator or screen
              return Center(
                  child: Container(
                      width: mediaQueryData.size.width / 5,
                      height: mediaQueryData.size.width / 5,
                      child:
                      CircularProgressIndicator())); // You can replace this with your loading screen widget.
            } else if (snapshot.hasError) {
              // If there's an error, show an error screen or message
              return Text('Error: ${snapshot.error}');
            } else {
              final docs = snapshot.data!.docs;
              return ListView.separated(
                itemCount: docs.length,
                itemBuilder: (context, index) =>
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                      title: Text(
                        "십시일반 적립금",
                        style: TextStyle(
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black),
                      ),
                      subtitle: Text(
                        docs[index]['earnDate'].toDate().toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                      trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${docs[index]['earnPoint']}P',
                                style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: MyColor.PRICE)),
                            Text(
                              '${docs[index]['totalPoint']}P',
                              style: TextStyle(
                                  fontSize: 10, color: MyColor.GRAY),
                            )
                          ]),
                    ),
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Divider());
                },
              );
            }
          });
    }else {
      return Center(
        child: Text("로그인 정보가 유효하지 않습니다"),
      );
    }
  }

  Widget _buildList2() {

    User? currentUser = getUser();

    if(currentUser != null) {
      final db = FirebaseFirestore.instance;
      // Replace this with your first list widget implementation
      return StreamBuilder<QuerySnapshot>(
          stream: db
              .collection("Restaurant")
              .doc(currentUser.email)
              .collection("RedeemList")
              .orderBy("redeemDate", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("차감 내역이 존재하지 않습니다"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              // While the data is being fetched, show a loading indicator or screen
              return Center(
                  child: Container(
                      width: mediaQueryData.size.width / 5,
                      height: mediaQueryData.size.width / 5,
                      child:
                      CircularProgressIndicator())); // You can replace this with your loading screen widget.
            } else if (snapshot.hasError) {
              // If there's an error, show an error screen or message
              return Text('Error: ${snapshot.error}');
            } else {
              final docs = snapshot.data!.docs;
              return ListView.separated(
                itemCount: docs.length,
                itemBuilder: (context, index) =>
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                      title: Text(
                        "십시일반 예약금 차감",
                        style: TextStyle(
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black),
                      ),
                      subtitle: Text(
                        docs[index]['redeemDate'].toDate().toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                      trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('-${docs[index]['redeemPoint']}P',
                                style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue)),
                            Text(
                              '${docs[index]['totalPoint']}P',
                              style: TextStyle(
                                  fontSize: 10, color: MyColor.GRAY),
                            )
                          ]),
                    ),
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Divider());
                },
              );
            }
          });
    } else {
      return Center(
        child: Text("로그인 정보가 유효하지 않습니다"),
      );
    }
  }
}
