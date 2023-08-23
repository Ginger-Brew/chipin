import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../colors.dart';
import '../base_appbar.dart';
import 'package:kpostal/kpostal.dart';
import '../base_button.dart';
import 'package:chipin/restaurant_main/RestaurantMain.dart';

class RestaurantInfoCorrection extends StatefulWidget {
  const RestaurantInfoCorrection({Key? key}) : super(key: key);

  @override
  State<RestaurantInfoCorrection> createState() => _RestaurantInfoCorrectionState();
}

class _RestaurantInfoCorrectionState extends State<RestaurantInfoCorrection> {
  //firestore에 저장할 때 사용할 컬렉션 이름과 도큐먼트 이름
  final String colName = "Restaurant";
  final String id = "jdh33114";
  String name = "";
  String address2 = "";
  String openH = "";
  String openM = "";
  String closeH = "";
  String closeM = "";
  String closeddays = "";
  String businessnumber = "";
  String phone = "";
  String banner = "";
  String location = "";



  //firestore에 이미지 저장할 때 쓸 변수
  String pickedImgPath = "";
  XFile pickedImg = XFile('');
  // String postCode = '-';
  String address1 = "-";
  String latitude = '-';
  String longitude = '-';
  // String kakaoLatitude = '-';
  // String kakaoLongitude = '-';

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
        businessnumber = data['businessnumber'];
        phone = data['phone'];
        pickedImgPath = data['banner'];


      });

      });
        }

  void updatedata() async {
    final db = FirebaseFirestore.instance.collection(colName).doc(id);

    if (_newRestaurantName.text != "") name = _newRestaurantName.text;
    if (_newRestaurantOpenHour.text != "") openH = _newRestaurantOpenHour.text;
    if (_newRestaurantOpenMinute.text != "") openM = _newRestaurantOpenMinute.text;
    if (_newRestaurantCloseHour.text != "") closeH = _newRestaurantCloseHour.text;
    if (_newRestaurantCloseMinute.text != "") closeM = _newRestaurantCloseMinute.text;
     if (_newRestaurantLocation.text != "") address2 = _newRestaurantLocation.text ;
    if (_newRestaurantClosedday.text != "") closeddays = _newRestaurantClosedday.text;
    if (_newRestaurantPhone.text != "") phone = _newRestaurantPhone.text;

      await db
          .update({
        'name': name,
        'address1': this.address1,
        'address2': address2,
        'openH':openH,
        'openM':openM,

        'closeH':closeH,
        'closeM':closeM,
        'closeddays': closeddays,
        'businessnumber': _newRestaurantBusinessNumber.text,
        'phone': phone,
        'banner': pickedImgPath
      })
          .then((value) => print("document added")) // firestore에 저장이 잘 된 경우
          .catchError((error) => print("Fail to add doc ${error}"));
      pickedImgPath = ""; // 변수 초기화

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image uploaded successfully')));


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


  @override
  Widget build(BuildContext context) {
    readdata();
    return Scaffold(
        appBar: const BaseAppBar(title: '가게 정보 수정하기'),
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
                RestaurantName(controller: _newRestaurantName, hint : name),
                SizedBox(height: 20),
                RestaurantPhone(controller: _newRestaurantPhone, hint : phone),
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
                          hintText: '${this.address1}'),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KpostalView(
                              // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
                              callback: (Kpostal result) {
                                setState(() {
                                  // this.postCode = result.postCode;
                                  this.address1 = result.address;
                                  this.latitude = result.latitude.toString();
                                  this.longitude = result.longitude.toString();
                                  // this.kakaoLatitude =
                                  //     result.kakaoLatitude.toString();
                                  // this.kakaoLongitude =
                                  //     result.kakaoLongitude.toString();
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
                            hintText: address2),
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
                    closeminutecontroller: _newRestaurantCloseMinute,
                    openHhint:openH,
                    openMhint:openM,
                    closeHhint:closeH,
                    closeMhint:closeM,
                ),
                SizedBox(height: 20),
                RestaurantClosedDay(
                  controller: _newRestaurantClosedday,
                  hint:closeddays
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
                  if(pickedImgPath != "")
                    Container(
                    width: 150, // Set the desired width
                    height: 100, // Set the desired height
                    child: Image.file(
                      File(pickedImgPath),
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
                      onPressed: () async {
                        updatedata();
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const RestaurantMain()));
                      }
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
  final String hint;

  const RestaurantName({Key? key, required this.controller, required this.hint}) : super(key: key);

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
          InputDecoration(border: OutlineInputBorder(), isDense: true, hintText: hint),
        )
      ],
    );
  }
}

class RestaurantPhone extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const RestaurantPhone({Key? key, required this.controller, required this.hint}) : super(key: key);

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
            InputDecoration(border: OutlineInputBorder(), isDense: true, hintText: hint),
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
  final String openHhint;
  final String openMhint;
  final String closeHhint;
  final String closeMhint;

  const RestaurantOpeningHour(
      {Key? key,
        required this.openhourcontroller,
        required this.openminutecontroller,
        required this.closehourcontroller,
        required this.closeminutecontroller,
      required this.openHhint,
      required this.openMhint,
      required this.closeHhint,
      required this.closeMhint
      })
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
                InputDecoration(border: OutlineInputBorder(), isDense: true, hintText: openHhint),
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
                InputDecoration(border: OutlineInputBorder(), isDense: true, hintText: openMhint),
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
              InputDecoration(border: OutlineInputBorder(), isDense: true, hintText: closeHhint),
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
              InputDecoration(border: OutlineInputBorder(), isDense: true, hintText: closeMhint),
            )),
      ]),
    ]);
  }
}

class RestaurantClosedDay extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const RestaurantClosedDay({Key? key, required this.controller, required this.hint})
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
        InputDecoration(border: OutlineInputBorder(), isDense: true, hintText: hint),
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
