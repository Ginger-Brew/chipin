import 'dart:io';

import 'package:chipin/restaurant_main/restaurant_info_correction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';
import 'package:chipin/base_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'restaurant_splitbutton.dart';
import 'restaurant_info.dart';
import 'restaurant_camera.dart';
import 'package:chipin/base_shadow.dart';
import 'restaurant_pointbutton.dart';
import 'package:chipin/restaurant_point_list/RestaurantEarnList.dart';

class RestaurantMain extends StatefulWidget {
  const RestaurantMain({Key? key}) : super(key: key);

  @override
  State<RestaurantMain> createState() => _RestaurantMainState();
}

class _RestaurantMainState extends State<RestaurantMain> {
  //firestore에 이미지 저장할 때 쓸 변수
  final String colName = "Restaurant";
  final String id = "jdh33114";
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

  void readdata() async {
    final db = FirebaseFirestore.instance.collection(colName).doc(id);

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

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    readdata();
    return Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: BaseAppBar(title: "십시일반"),
        body: Container(
            child: SingleChildScrollView(
                child: Center(
                    child: Column(children: [
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: PointButton(),
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
                              address: address1 + address2,
                              open: openH + ":" + openM,
                              close: closeH + ":" + closeM,
                              phone: phone,
                              closeddays: closeddays,
                              name: name,
                              banner: banner)),
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

  RestaurantInfoButton({
    Key? key,
    required this.name,
    required this.address,
    required this.open,
    required this.close,
    required this.closeddays,
    required this.phone,
    required this.banner,
  }) : super(key: key);

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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                foregroundColor: MyColor.HOVER),
            onPressed: () {},
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    if(banner != "")
                    Container(
                      width: 300, // Set the desired width
                      height: 200, // Set the desired height
                      child: Image.file(
                        File(banner),
                        fit: BoxFit.cover,
                      ),
                    )
                    else
                      Container(
                      width: 300, // Set the desired width
                      height: 200, // Set the desired height
                      child:
                        Image.asset(
                          'assets/images/nobanner.png',fit: BoxFit.cover
                        ),

                      ),


                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Mainfonts",
                              color: Colors.black),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "십시일반 포인트",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Mainfonts",
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "3500P",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Mainfonts",
                              color: MyColor.PRICE),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Icon(CupertinoIcons.placemark_fill,
                            color: Colors.black),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          address,
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
                          closeddays,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Mainfonts",
                              color: Colors.black),
                        )
                      ],
                    ),
                  ],
                ))));
  }
}
