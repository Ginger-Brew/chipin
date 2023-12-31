import 'package:chipin/colors.dart';
import 'package:chipin/restaurant_main/restaurant_info_correction.dart';
import 'package:chipin/restaurant_point_list/RestaurantEarnList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/utils/size_utils.dart';
import '../restaurant_appbar/RestaurantAppBar.dart';
import '../restaurant_appbar/RestaurantDrawerMenu.dart';
import 'my_restaurant_container_screen.dart';
import 'restaurant_camera.dart';

class RestaurantMain extends StatefulWidget {
  const RestaurantMain({Key? key}) : super(key: key);

  @override
  State<RestaurantMain> createState() => _RestaurantMainState();
}

class _RestaurantMainState extends State<RestaurantMain> {
  //firestore에 이미지 저장할 때 쓸 변수
  final String colName = "Restaurant";
  String name = "";
  String address1 = "-";
  String address2 = "";
  String openH = "";
  String openM = "";
  String closeH = "";
  String closeM = "";
  String closeddays = "";
  String phone = "";
  String banner = "";
  String ownerId = "";

  void initState() {
    super.initState();
    readInfoData();
  }

  Future<void> readInfoData() async {
    User? currentUser = getUser();
    if (currentUser != null) {
      final db =
          FirebaseFirestore.instance.collection(colName).doc(currentUser.email);

      debugPrint("debug: +${currentUser.email}");

      await db.get().then((DocumentSnapshot ds) {
        Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

        setState(() {
          name = data['name'];
          address1 = data['address1'];
          address2 = data['address2'];
          openH = data['openH'];
          openM = data['openM'];
          closeH = data['closeH'];
          closeM = data['closeM'];
          closeddays = data['closeddays'];
          phone = data['phone'];
          banner = data['banner'];
          ownerId = currentUser.email!;
        });
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('로그인 정보가 유효하지 않습니다')));
    }
  }

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

  Future<num> readRemainingData() async {
    User? currentUser = getUser();
    num earnPoint = 0;
    num redeemPoint = 0;

    if (currentUser != null) {
      final db =
          FirebaseFirestore.instance.collection(colName).doc(currentUser.email);

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

    return earnPoint - redeemPoint;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: RestaurantAppBar(title: "십시일반"),
        endDrawer: RestaurantDrawerMenu(),
        body: Container(
            child: SingleChildScrollView(
                child: Center(
                    child: Column(children: [
          SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: Container(
                    height: 110,
                    margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 0.0,
                          offset: const Offset(0, 7))
                    ]),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.white,
                            foregroundColor: MyColor.HOVER),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RestaurantEarnList()));
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
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: "Mainfonts"),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Image.asset(
                                          'assets/images/coins.png')),
                                ),
                                // SizedBox(height: 8),
                                Expanded(
                                    flex: 2,
                                    child: FutureBuilder<num>(
                                        future: readRemainingData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child: Container(
                                                    width: (mediaQueryData
                                                                .size.width -
                                                            43) /
                                                        15,
                                                    height: (mediaQueryData
                                                                .size.width -
                                                            43) /
                                                        15,
                                                    child:
                                                        CircularProgressIndicator())); // You can replace this with your loading screen widget.
                                          } else if (snapshot.hasError) {
                                            // If there's an error, show an error screen or messag
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            final remainingPoint =
                                                snapshot.data;
                                            return Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '$remainingPoint 원',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                  fontFamily: "Mainfonts",
                                                ),
                                              ),
                                            );
                                          }
                                        }))
                              ],
                            ),
                          ],
                        ))),
              ),
              Expanded(
                child: InfoCorrectionButton(),
              )
            ],
          ),
          SizedBox(height: 20),
          Container(height: 111, child: CameraButton()),
          SizedBox(height: 20),
          Container(
              height: 420,
              child: RestaurantInfoButton(
                  address: this.address1 + " " + this.address2,
                  open: this.openH + ":" + this.openM,
                  close: this.closeH + ":" + this.closeM,
                  phone: this.phone,
                  closeddays: this.closeddays,
                  name: this.name,
                  banner: this.banner,
                  ownerId: this.ownerId)),
          SizedBox(
            height: 20,
          ),
        ])))));
  }
}

class RestaurantInfoButton extends StatelessWidget {
  String name;
  String address;
  String open;
  String close;
  String closeddays;
  String phone;
  String banner;
  String ownerId;

  RestaurantInfoButton(
      {Key? key,
      required this.name,
      required this.address,
      required this.open,
      required this.close,
      required this.closeddays,
      required this.phone,
      required this.banner,
      required this.ownerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              spreadRadius: 0.0,
              offset: const Offset(0, 7))
        ]),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                foregroundColor: MyColor.HOVER),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyRestaurantContainerScreen(
                          title: name,
                          location: address,
                          time: close,
                          banner: banner,
                          ownerId: ownerId)));
            },
            child: Column(
              children: [
                if (banner != "")
                  Container(
                    width: 300, // Set the desired width
                    height: 200, // Set the desired height
                    child: Image.network(
                      banner,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: 300, // Set the desired width
                    height: 200, // Set the desired height
                    child: Image.asset('assets/images/nobanner.png',
                        fit: BoxFit.cover),
                  ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        name,
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Mainfonts",
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(),
                Row(
                  children: [
                    Icon(CupertinoIcons.placemark_fill, color: Colors.black),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        address,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Mainfonts",
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(CupertinoIcons.clock_fill, color: Colors.black),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      open + "~" + close,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Mainfonts",
                          color: Colors.black),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(CupertinoIcons.calendar, color: Colors.black),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      closeddays,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Mainfonts",
                          color: Colors.black),
                    )
                  ],
                ),
              ],
            )));
  }
}
