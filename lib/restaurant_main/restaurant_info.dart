import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';
import 'package:image_picker/image_picker.dart';

class ShadowButton extends StatefulWidget {
  const ShadowButton({Key? key}) : super(key: key);

  @override
  State<ShadowButton> createState() => _ShadowButtonState();
}

class _ShadowButtonState extends State<ShadowButton> {
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
  String pickedImgPath = "";
  XFile pickedImg = XFile('');


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
        pickedImgPath = data['banner'];


      });

    });
  }

  @override
  Widget build(BuildContext context) {
    readdata();
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
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
                    Image.asset(
                      'assets/images/ohyang_restaurant.png',
                    ),
                    SizedBox(height: 20,),
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
                          "충남 보령시 보령남로 125-7",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Mainfonts",
                              color: Colors.black),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(CupertinoIcons.clock_fill, color: Colors.black),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "매일 09:00 ~ 19:00",
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