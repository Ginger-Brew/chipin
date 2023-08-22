import 'dart:io';

import 'package:chipin/colors.dart';
import 'package:chipin/restaurant_main/RestaurantMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chipin/base_appbar.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../restaurant_register/restaurant_register_component.dart';
import 'package:chipin/base_button.dart';
import '../base_time_picker.dart';

class RestaurantRegister extends StatefulWidget {
  const RestaurantRegister({Key? key}) : super(key: key);

  @override
  State<RestaurantRegister> createState() => _RestaurantRegisterState();
}

class _RestaurantRegisterState extends State<RestaurantRegister> {
  final String colName = "Restaurant";
  final String id = "jdh33114";

  TextEditingController _newRestaurantName = TextEditingController();
  TextEditingController _newRestaurantLocation = TextEditingController();
  TextEditingController _newRestaurantPhone = TextEditingController();
  TextEditingController _newRestaurantClosedday = TextEditingController();
  TextEditingController _newRestaurantBusinessNumber = TextEditingController();
  TextEditingController _newRestaurantOpenHour = TextEditingController();
  TextEditingController _newRestaurantOpenMinute = TextEditingController();
  TextEditingController _newRestaurantCloseHour = TextEditingController();
  TextEditingController _newRestaurantCloseMinute = TextEditingController();

  @override
  void dispose() {
    _newRestaurantName.dispose();
    _newRestaurantClosedday.dispose();
    _newRestaurantCloseHour.dispose();
    _newRestaurantCloseMinute.dispose();
    _newRestaurantOpenHour.dispose();
    _newRestaurantOpenMinute.dispose();
    _newRestaurantLocation.dispose();
    _newRestaurantBusinessNumber.dispose();
    _newRestaurantPhone.dispose();
  }

  void writedata() async {
    final db = FirebaseFirestore.instance.collection(colName).doc(id);

    final docRef = db
        .collection(id)
        .doc("RestaurantInfo"); // Create a new document reference

    // Now you can use 'await' within the 'main' function
    if (pickedImgPath != "") {
      await db
          .set({
            'name': _newRestaurantName.text,
            'location': _newRestaurantLocation.text,
            'open': _newRestaurantOpenHour.text +
                ":" +
                _newRestaurantOpenMinute.text,
            'close': _newRestaurantCloseHour.text +
                ":" +
                _newRestaurantCloseMinute.text,
            'closeddays': _newRestaurantClosedday.text,
            'businessnumber': _newRestaurantBusinessNumber.text,
            'phone': _newRestaurantPhone.text,
            'banner': pickedImgPath
          })
          .then((value) => print("document added")) //잘 들어갔니?
          .catchError((error) => print("Fail to add doc ${error}"));
      pickedImgPath = "";

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image uploaded successfully')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No image selected')));
    }
  }

  final ImagePicker _picker = ImagePicker();
  String pickedImgPath = "";
  XFile pickedImg = XFile('');

  Future _pickImg() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImgPath = image.path;
        pickedImg = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BaseAppBar(title: '가게 정보 등록하기'),
        body: Container(
          color: MyColor.BACKGROUND,
          padding: const EdgeInsets.symmetric(
            horizontal: 31,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 50),
                RestaurantName(controller: _newRestaurantName),
                SizedBox(height: 50),
                RestaurantPhone(controller: _newRestaurantPhone),
                SizedBox(height: 50),
                RestaurantBusinessRegistrationNumber(
                  controller: _newRestaurantBusinessNumber,
                ),
                SizedBox(height: 50),
                RestaurantLocation(
                  controller: _newRestaurantLocation,
                ),
                SizedBox(height: 50),
                RestaurantOpeningHour(
                    openhourcontroller: _newRestaurantOpenHour,
                    openminutecontroller: _newRestaurantOpenMinute,
                    closehourcontroller: _newRestaurantCloseHour,
                    closeminutecontroller: _newRestaurantCloseMinute),
                SizedBox(height: 50),
                RestaurantClosedDay(
                  controller: _newRestaurantClosedday,
                ),
                SizedBox(height: 50),
                Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text('가게 대표\n사진 등록',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: "Mainfonts")),
                        ),
                        Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                BaseButton(
                                  text: "파일 첨부",
                                  fontsize: 13,
                                  onPressed: () => _pickImg(),
                                ),
                              ],
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(flex:1 , child: SizedBox(width: 10,)),
                        Expanded(
                            flex: 4,
                            child: Container(
                              width: 150, // Set the desired width
                              height: 100, // Set the desired height
                              child: Image.file(
                                File(pickedImg.path),
                                fit: BoxFit.cover,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
                SizedBox(height: 50),
                RestaurantMenu(),
                SizedBox(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                      child: Text("등록", style: TextStyle(fontSize: 16)),
                      onPressed: () => writedata()
                      // Navigator.push(context,
                      // MaterialPageRoute(builder: (context) => const RestaurantMain())
                      )
                ]),
                SizedBox(height: 50),
              ],
            ),
          ),
        ));
  }
}

class RestaurantName extends StatelessWidget {
  final TextEditingController controller;

  const RestaurantName({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RestaurantRegisterComponent(
        subject:
            Text('상호', style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
        form: TextField(
          controller: controller,
        ));
  }
}

class RestaurantPhone extends StatelessWidget {
  final TextEditingController controller;

  const RestaurantPhone({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RestaurantRegisterComponent(
        subject: Text('유선전화',
            style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
        form: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly]));
  }
}

class RestaurantLocation extends StatelessWidget {
  final TextEditingController controller;

  const RestaurantLocation({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            width: 70,
            child: Text('주소',
                style: TextStyle(fontSize: 16, fontFamily: "Mainfonts"))),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              RestaurantRegisterComponent(
                  subject: Text('도로명'), form: TextField()),
              RestaurantRegisterComponent(
                  subject: Text('상세 주소'),
                  form: TextField(controller: controller))
            ],
          ),
        ),
      ],
    );
  }
}

class RestaurantOpeningHour extends StatelessWidget {
  final TextEditingController openhourcontroller;
  final TextEditingController openminutecontroller;
  final TextEditingController closehourcontroller;
  final TextEditingController closeminutecontroller;

  const RestaurantOpeningHour(
      {Key? key,
      required this.openhourcontroller,
      required this.openminutecontroller,
      required this.closehourcontroller,
      required this.closeminutecontroller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
          width: 70,
          child: Text('영업 시간',
              style: TextStyle(fontSize: 16, fontFamily: "Mainfonts"))),
      const SizedBox(width: 10),
      Expanded(
          child: Column(children: [
        Row(
          children: <Widget>[
            Container(width: 70, child: Text('오픈 시간')),
            SizedBox(width: 30),
            Expanded(
                child: TextField(
              controller: openhourcontroller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration:
                  InputDecoration(border: OutlineInputBorder(), isDense: true),
            )),
            SizedBox(width: 10),
            Text(
              ":",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextField(
              controller: openminutecontroller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration:
                  InputDecoration(border: OutlineInputBorder(), isDense: true),
            )),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(children: <Widget>[
          Container(width: 70, child: Text('마감 시간')),
          SizedBox(width: 30),
          Expanded(
              child: TextField(
            controller: closehourcontroller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration:
                InputDecoration(border: OutlineInputBorder(), isDense: true),
          )),
          SizedBox(width: 10),
          Text(
            ":",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: TextField(
            controller: closeminutecontroller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration:
                InputDecoration(border: OutlineInputBorder(), isDense: true),
          )),
        ]),
      ]))
    ]);
  }
}

class RestaurantClosedDay extends StatelessWidget {
  final TextEditingController controller;

  const RestaurantClosedDay({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RestaurantRegisterComponent(
        subject: Text('휴무일',
            style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
        form: TextField(
          controller: controller,
        ));
  }
}

class RestaurantBusinessRegistrationNumber extends StatelessWidget {
  final TextEditingController controller;

  const RestaurantBusinessRegistrationNumber(
      {Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            width: 70,
            child: Text('사업자\n등록 번호',
                style: TextStyle(fontFamily: "Mainfonts", fontSize: 16))),
        SizedBox(width: 10),
        Expanded(
            child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly])),
      ],
    );
    ;
  }
}

class RestaurantMenu extends StatefulWidget {
  const RestaurantMenu({Key? key}) : super(key: key);

  @override
  State<RestaurantMenu> createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  final TextEditingController menuname = TextEditingController();
  final TextEditingController menuprice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('메뉴',
              style: TextStyle(fontSize: 16, fontFamily: "Mainfonts")),
        ),
        Expanded(
            flex: 4,
            child: Column(
              children: [
                BaseButton(
                  text: "메뉴 추가",
                  fontsize: 13,
                  onPressed: () => showMenuDialog(context),
                ),
              ],
            ))
      ],
    );
  }

  Future<dynamic> showMenuDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text(
              "메뉴 추가하기",
              style: TextStyle(fontFamily: "Mainfonts", fontSize: 24),
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "메뉴명",
                    style: TextStyle(fontFamily: "Mainfonts", fontSize: 16),
                  )),
              SizedBox(
                height: 7,
              ),
              TextField(
                controller: menuname,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), isDense: true),
              ),
              SizedBox(
                height: 40,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "가격",
                    style: TextStyle(fontFamily: "Mainfonts", fontSize: 16),
                  )),
              SizedBox(
                height: 7,
              ),
              TextField(
                controller: menuprice,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    border: OutlineInputBorder(), isDense: true),
              ),
            ]),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    menuname.text = "";
                    menuprice.text = "";
                  },
                  child: Text(
                    "취소",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Pretendard",
                        color: Colors.black),
                  )),
              ElevatedButton(
                onPressed: () {
                  menuprice.text = "";
                  menuname.text = "";
                  Navigator.pop(context);
                },
                child: Text("추가하기",
                    style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 16,
                        color: Colors.black)),
              )
            ],
          );
        });
  }
}

// class RegisterButton extends StatelessWidget {
//   final VoidCallback? onPressed;
//
//   const RegisterButton({Key? key, this.onPressed}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//       BaseButton(text: "등록", fontsize: 16, onPressed: () => onPressed
//           // Navigator.push(context,
//           // MaterialPageRoute(builder: (context) => const RestaurantMain())
//           )
//     ]);
//   }
// }
