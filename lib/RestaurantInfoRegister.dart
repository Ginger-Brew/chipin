import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'colors.dart';
import 'base_appbar.dart';
import 'package:kpostal/kpostal.dart';
import 'base_button.dart';

class RestaurantInfoRegister extends StatefulWidget {
  const RestaurantInfoRegister({Key? key}) : super(key: key);

  @override
  State<RestaurantInfoRegister> createState() => _RestaurantInfoRegisterState();
}

class _RestaurantInfoRegisterState extends State<RestaurantInfoRegister> {
  //firestore에 저장할 때 사용할 컬렉션 이름과 도큐먼트 이름
  final String colName = "Restaurant";
  final String id = "jdh33114";

  //firestore에 이미지 저장할 때 쓸 변수
  String pickedImgPath = "";
  XFile pickedImg = XFile('');
  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

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

    // firestore에 저장
    if (pickedImgPath != "") {
      await db
          .set({
            'name': _newRestaurantName.text,
            'location': '${this.address} ${_newRestaurantLocation.text}',
            'open':
                "${_newRestaurantOpenHour.text}:${_newRestaurantOpenMinute.text}",
            'close':
                "${_newRestaurantCloseHour.text}:${_newRestaurantCloseMinute.text}",
            'closeddays': _newRestaurantClosedday.text,
            'businessnumber': _newRestaurantBusinessNumber.text,
            'phone': _newRestaurantPhone.text,
            'banner': pickedImgPath
          })
          .then((value) => print("document added")) // firestore에 저장이 잘 된 경우
          .catchError((error) => print("Fail to add doc ${error}"));
      pickedImgPath = ""; // 변수 초기화

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image uploaded successfully')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No image selected')));
    }
  }

  Future pickImg() async {
    final ImagePicker _picker = ImagePicker();

    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImgPath = image.path;
        pickedImg = image;
      });
    }
  }

  Future kakaoApi() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KpostalView(
            callback: (Kpostal result) {
              print(result.address);
              address = result.address;
              this.postCode = result.postCode;
              this.address = result.address;
              this.latitude = result.latitude.toString();
              this.longitude = result.longitude.toString();
              this.kakaoLatitude = result.kakaoLatitude.toString();
              this.kakaoLongitude = result.kakaoLongitude.toString();
            },
          ),
        ));
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
              children: [
                SizedBox(height: 50),
                RestaurantName(controller: _newRestaurantName),
                SizedBox(height: 20),
                RestaurantPhone(controller: _newRestaurantPhone),
                SizedBox(height: 20),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('주소',
                          style:
                              TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: '${this.address}'),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KpostalView(
                              // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
                              callback: (Kpostal result) {
                                setState(() {
                                  this.postCode = result.postCode;
                                  this.address = result.address;
                                  this.latitude = result.latitude.toString();
                                  this.longitude = result.longitude.toString();
                                  this.kakaoLatitude =
                                      result.kakaoLatitude.toString();
                                  this.kakaoLongitude =
                                      result.kakaoLongitude.toString();
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            hintText: "상세 주소를 입력해주세요"),
                        controller: _newRestaurantLocation)
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('사업자 등록 번호',
                          style:
                              TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), isDense: true),
                        onTap: () => {}),
                  ],
                ),
                SizedBox(height: 70),
                RestaurantOpeningHour(
                    openhourcontroller: _newRestaurantOpenHour,
                    openminutecontroller: _newRestaurantOpenMinute,
                    closehourcontroller: _newRestaurantCloseHour,
                    closeminutecontroller: _newRestaurantCloseMinute),
                SizedBox(height: 20),
                RestaurantClosedDay(
                  controller: _newRestaurantClosedday,
                ),
                SizedBox(height: 20),
                Column(children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('가게 대표 사진 등록',
                        style:
                            TextStyle(fontSize: 16, fontFamily: "Mainfonts")),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseButton(
                    text: "파일 첨부",
                    fontsize: 13,
                    onPressed: () => pickImg(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 150, // Set the desired width
                    height: 100, // Set the desired height
                    child: Image.file(
                      File(pickedImg.path),
                      fit: BoxFit.cover,
                    ),
                  )
                ]),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
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
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text('상호',
                style: TextStyle(fontFamily: "Mainfonts", fontSize: 16))),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
          decoration:
              InputDecoration(border: OutlineInputBorder(), isDense: true),
        )
      ],
    );
  }
}

class RestaurantPhone extends StatelessWidget {
  final TextEditingController controller;

  const RestaurantPhone({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text('유선전화',
                style: TextStyle(fontFamily: "Mainfonts", fontSize: 16))),
        SizedBox(
          height: 10,
        ),
        TextField(
            controller: controller,
            decoration:
                InputDecoration(border: OutlineInputBorder(), isDense: true),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly])
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
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text('영업 시간',
              style: TextStyle(fontSize: 16, fontFamily: "Mainfonts"))),
      SizedBox(
        height: 10,
      ),
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
    ]);
  }
}

class RestaurantClosedDay extends StatelessWidget {
  final TextEditingController controller;

  const RestaurantClosedDay({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text('휴무일',
              style: TextStyle(fontFamily: "Mainfonts", fontSize: 16))),
      SizedBox(
        height: 10,
      ),
      TextField(
        decoration:
            InputDecoration(border: OutlineInputBorder(), isDense: true),
        controller: controller,
      )
    ]);
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
    return Column(
      children: <Widget>[
        Align(alignment:Alignment.centerLeft,child: Text('메뉴', style: TextStyle(fontSize: 16, fontFamily: "Mainfonts"))),
        SizedBox(
          height: 10,
        ),
        BaseButton(
          text: "메뉴 추가",
          fontsize: 13,
          onPressed: () => showMenuDialog(context),
        ),
        SizedBox(
          height: 20,
        ),
        Text('가게 등록을 위해\n한 개 이상의 메뉴를 등록해주세요',
            style: TextStyle(fontSize: 13, fontFamily: "Pretendard"),textAlign: TextAlign.center,)
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
