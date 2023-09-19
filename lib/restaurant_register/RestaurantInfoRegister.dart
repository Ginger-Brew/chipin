import 'dart:io';

import 'package:chipin/restaurant_main/RestaurantMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../colors.dart';
import '../base_appbar.dart';
import 'package:kpostal/kpostal.dart';
import '../base_button.dart';
import '../core/utils/size_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<NewMenu> menuItems = [];
int menuCount = 0;

class RestaurantInfoRegister extends StatefulWidget {
  const RestaurantInfoRegister({Key? key}) : super(key: key);

  @override
  State<RestaurantInfoRegister> createState() => _RestaurantInfoRegisterState();
}

class _RestaurantInfoRegisterState extends State<RestaurantInfoRegister> {
  //firestore에 저장할 때 사용할 컬렉션 이름과 도큐먼트 이름
  final String colName = "Restaurant";
  String beResult = "-를 제외한 10자리 숫자만 입력해주세요";

  //firestore에 이미지 저장할 때 쓸 변수
  String pickedImgPath = "";
  XFile pickedImg = XFile('');
  String address1 = "";
  String latitude = '';
  String longitude = '';

  bool isValidBsNum = false;

  bool isPresentBsNum = true;
  bool isPresentName = true;
  bool isPresentTel = true;
  bool isPresentCloseDay = true;
  bool isPresentAddr = true;
  bool isPresentOpeningHour = true;
  bool isPresentMenu = true;
  bool isPresentImg = true;

  TextEditingController _newRestaurantName = TextEditingController();
  TextEditingController _newRestaurantLocation = TextEditingController();
  TextEditingController _newRestaurantPhone = TextEditingController();
  TextEditingController _newRestaurantClosedday = TextEditingController();
  TextEditingController _newRestaurantBusinessNumber = TextEditingController();
  TextEditingController _newRestaurantOpenHour = TextEditingController();
  TextEditingController _newRestaurantOpenMinute = TextEditingController();
  TextEditingController _newRestaurantCloseHour = TextEditingController();
  TextEditingController _newRestaurantCloseMinute = TextEditingController();

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
    super.dispose();
  }

  bool checkValid() {
    bool validCheck = true;
    isPresentBsNum = true;
    isPresentName = true;
    isPresentTel = true;
    isPresentAddr = true;
    isPresentCloseDay = true;
    isPresentOpeningHour = true;
    isPresentMenu = true;
    isPresentImg = true;

    setState(() {
      if (_newRestaurantName.text == "") {
        validCheck = false;
        isPresentName = false;
      }
      if (_newRestaurantLocation.text == "" || address1 == "") {
        validCheck = false;
        isPresentAddr = false;
      }
      if (_newRestaurantPhone.text == "") {
        validCheck = false;
        isPresentTel = false;
      }
      if (_newRestaurantBusinessNumber.text == "") {
        validCheck = false;
        isPresentBsNum = false;
      }
      if (_newRestaurantClosedday.text == "") {
        validCheck = false;
        isPresentCloseDay = false;
      }
      if (_newRestaurantOpenHour.text == "" ||
          _newRestaurantOpenMinute.text == "" ||
          _newRestaurantCloseHour.text == "" ||
          _newRestaurantCloseMinute.text == "") {
        validCheck = false;
        isPresentOpeningHour = false;
      }
      if (menuItems.isEmpty) {
        validCheck = false;
        isPresentMenu = false;
      }
      if (pickedImgPath == "") {
        validCheck = false;
        isPresentImg = false;
      }
    });
    return validCheck;
  }

  void writeinfodata() async {
    User? currentUser = getUser();

    if (currentUser != null) {
      final db =
          FirebaseFirestore.instance.collection(colName).doc(currentUser.email);

      // firestore에 저장
      await db
          .set({
            'name': _newRestaurantName.text,
            'address1': this.address1,
            'address2': _newRestaurantLocation.text,
            'latitude': this.latitude,
            'longitude': this.longitude,
            'openH': _newRestaurantOpenHour.text,
            'openM': _newRestaurantOpenMinute.text,
            'closeH': _newRestaurantCloseHour.text,
            'closeM': _newRestaurantCloseMinute.text,
            'closeddays': _newRestaurantClosedday.text,
            'businessnumber': _newRestaurantBusinessNumber.text,
            'phone': _newRestaurantPhone.text,
            'banner': pickedImgPath
          })
          .then((value) => print("document added")) // firestore에 저장이 잘 된 경우
          .catchError((error) => print("Fail to add doc ${error}"));
      pickedImgPath = ""; // 변수 초기화

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('가게 정보가 등록되었습니다')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('로그인 정보가 유효하지 않습니다')));
    }
  }

  void writemenudata(String menu, String price, String explain) async {
    User? currentUser = getUser();
    if (currentUser != null) {
      final db = FirebaseFirestore.instance
          .collection(colName)
          .doc(currentUser.email)
          .collection("Menu")
          .doc(menu);

      await db
          .set({'name': menu, 'price': price, 'explain': explain})
          .then((value) => print("document added")) // firestore에 저장이 잘 된 경우
          .catchError((error) => print("Fail to add doc ${error}"));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('사용자 정보가 유효하지 않습니다')));
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

  Future<void> requestGalleryPermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      await pickImg();
    } else {
      // 권한이 거부되었을 때 사용자에게 설명을 제공하거나 다시 권한을 요청할 수 있는 UI를 표시합니다.
    }
  }

  Future<void> checkBusinessNumber() async {
    String reg1 = _newRestaurantBusinessNumber.text;
    String bsNum = reg1;

    if (bsNum.length == 10) {
      try {
        // First, send a POST request to an API
        final response = await http.post(
          Uri.parse(
              "https://api.odcloud.kr/api/nts-businessman/v1/status?serviceKey=ojn0FinFuT9TLfshP39B49UkYEyiPYtsMozX94RMoiyb%2BI4Q%2Bw9GRC5gnpPMEg48oMjRz0XE3fPja6Yh4jU9cw%3D%3D"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "b_no": [bsNum],
          }),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> result = jsonDecode(response.body);
          String code = result['data'][0]['b_stt_cd'];

          setState(() {
            if (code == "01") {
              beResult = "사업자 번호 확인이 완료되었습니다";
              isValidBsNum = true;
            } else if (code == "02" || code == "03") {
              beResult = "휴/폐업한 사업자번호입니다";
            } else {
              beResult = "등록되지 않은 사업자번호입니다";
            }
          });
        } else {
          setState(() {
            beResult = "올바른 사업자 번호를 입력해주세요";
          });
        }
      } catch (e) {
        // Handle exceptions
      }
    } else {
      setState(() {
        beResult = "사업자 번호는 10자여야 합니다";
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
              children: [
                SizedBox(height: 50),
                RestaurantName(
                  controller: _newRestaurantName,
                  isPresentName: isPresentName,
                ),
                SizedBox(height: 20),
                RestaurantPhone(
                  controller: _newRestaurantPhone,
                  isPresentPhone: isPresentTel,
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('주소',
                            style: TextStyle(
                                fontFamily: "Mainfonts", fontSize: 16)),
                        SizedBox(width: 10),
                        if (!isPresentAddr)
                          Text("* 주소를 입력해주세요",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Pretendard",
                                  color: Colors.red))
                      ],
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
                              callback: (Kpostal result) {
                                setState(() {
                                  this.address1 = result.address;
                                  this.latitude = result.latitude.toString();
                                  this.longitude = result.longitude.toString();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('사업자 등록 번호',
                            style: TextStyle(
                                fontFamily: "Mainfonts", fontSize: 16)),
                        SizedBox(
                          width: 10,
                        ),
                        if (!isPresentBsNum)
                          Text("* 사업자 등록 번호를 입력해주세요",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Pretendard",
                                  color: Colors.red))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                              // maxLength: 10,
                              controller: _newRestaurantBusinessNumber,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(), isDense: true),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onTap: () => {}),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                            child: Text("확인",
                                style: TextStyle(
                                    fontFamily: "Pretendard", fontSize: 16)),
                            onPressed: checkBusinessNumber)
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (isValidBsNum)
                      Text(beResult,
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Pretendard",
                              color: Colors.green))
                    else if (!isValidBsNum)
                      Text(beResult,
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Pretendard",
                              color: Colors.red))
                  ],
                ),
                SizedBox(height: 70),
                RestaurantOpeningHour(
                    openhourcontroller: _newRestaurantOpenHour,
                    openminutecontroller: _newRestaurantOpenMinute,
                    closehourcontroller: _newRestaurantCloseHour,
                    closeminutecontroller: _newRestaurantCloseMinute,
                    isPresentOpeningHour: isPresentOpeningHour),
                SizedBox(height: 20),
                RestaurantClosedDay(
                    controller: _newRestaurantClosedday,
                    isPresentCloseDay: isPresentCloseDay),
                SizedBox(height: 20),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text('가게 대표 사진 등록',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: "Mainfonts")),
                          SizedBox(
                            width: 10,
                          ),
                          if (!isPresentImg)
                            Text("* 가게 대표 사진을 등록해주세요",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Pretendard",
                                    color: Colors.red))
                        ],
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
                      if (pickedImg.path.isNotEmpty)
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
                RestaurantMenu(isPresentMenu: isPresentMenu),
                SizedBox(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                      child: Text("등록",
                          style: TextStyle(
                              fontSize: 16, fontFamily: "Pretendard")),
                      onPressed: () {
                        if (checkValid() && isValidBsNum) {
                          writeinfodata();

                          for (int i = 0; i < menuItems.length; i++) {
                            writemenudata(
                                menuItems[i].menuname,
                                menuItems[i].menuprice,
                                menuItems[i].menuexplain);
                          }

                        Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RestaurantMain()),(route) => false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('입력되지 않은 값이 있습니다')));
                        }
                      })
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
  final bool isPresentName;

  const RestaurantName(
      {Key? key, required this.controller, required this.isPresentName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('상호', style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
            SizedBox(width: 10),
            if (!isPresentName)
              Text("* 상호를 입력해주세요",
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Pretendard",
                      color: Colors.red))
          ],
        ),
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
  final bool isPresentPhone;

  const RestaurantPhone(
      {Key? key, required this.controller, required this.isPresentPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('유선전화',
                style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
            SizedBox(width: 10),
            if (!isPresentPhone)
              Text("* 전화번호를 입력해주세요",
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Pretendard",
                      color: Colors.red))
          ],
        ),
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
  final bool isPresentOpeningHour;

  const RestaurantOpeningHour(
      {Key? key,
      required this.openhourcontroller,
      required this.openminutecontroller,
      required this.closehourcontroller,
      required this.closeminutecontroller,
      required this.isPresentOpeningHour})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Text('영업 시간',
              style: TextStyle(fontSize: 16, fontFamily: "Mainfonts")),
          SizedBox(width: 10),
          if (!isPresentOpeningHour)
            Text("* 영업 시간을 입력해주세요",
                style: TextStyle(
                    fontSize: 13, fontFamily: "Pretendard", color: Colors.red))
        ],
      ),
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
  final bool isPresentCloseDay;

  const RestaurantClosedDay(
      {Key? key, required this.controller, required this.isPresentCloseDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Text('휴무일', style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
          SizedBox(width: 10),
          if (!isPresentCloseDay)
            Text("* 휴무일을 입력해주세요",
                style: TextStyle(
                    fontSize: 13, fontFamily: "Pretendard", color: Colors.red)),
        ],
      ),
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
  final bool isPresentMenu;

  const RestaurantMenu({Key? key, required this.isPresentMenu})
      : super(key: key);

  @override
  State<RestaurantMenu> createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  final String colName = "Restaurant";
  final String id = "jdh33114";
  final TextEditingController menuname = TextEditingController();
  final TextEditingController menuprice = TextEditingController();
  final TextEditingController menuexplain = TextEditingController();

  @override
  void dispose() {
    menuname.dispose();
    menuprice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            Text('메뉴', style: TextStyle(fontSize: 16, fontFamily: "Mainfonts")),
            SizedBox(width: 10),
            if (!widget.isPresentMenu)
              Text("* 한 개 이상의 메뉴를 등록해주세요",
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Pretendard",
                      color: Colors.red)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        BaseButton(
          text: "메뉴 추가",
          fontsize: 13,
          onPressed: () => showMenuDialog(context, menuCount++),
        ),
        SizedBox(
          height: 20,
        ),
        if (menuItems.isEmpty)
          Text(
            '가게 등록을 위해\n한 개 이상의 메뉴를 등록해주세요',
            style: TextStyle(fontSize: 13, fontFamily: "Pretendard"),
            textAlign: TextAlign.center,
          ),
        if (menuItems.isNotEmpty)
          Container(
            width: mediaQueryData.size.width - 50,
            height: mediaQueryData.size.height / 3,
            child: ListView.separated(
              // shrinkWrap: true,
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  // visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                  title: Text(
                    menuItems[index].menuname,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  subtitle: Text(menuItems[index].menuexplain,
                      style: TextStyle(color: MyColor.GRAY, fontSize: 13)),
                  trailing: Container(
                    width: mediaQueryData.size.width / 3,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            menuItems[index].menuprice + "원",
                            style:
                                TextStyle(fontSize: 15, color: MyColor.PRICE),
                          ),
                        ),
                        Expanded(
                            child: TextButton(
                                onPressed: () {
                                  showMenuUpdateDialog(
                                      context,
                                      menuItems[index].menuname,
                                      menuItems[index].menuprice,
                                      menuItems[index].menuexplain,
                                      index);
                                },
                                child: Text("수정",
                                    style: TextStyle(
                                        color: MyColor.GOLD_YELLOW,
                                        fontSize: 13)))),
                        Expanded(
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    menuItems.removeAt(index);
                                  });
                                },
                                child: Text("삭제",
                                    style: TextStyle(
                                        color: MyColor.GOLD_YELLOW,
                                        fontSize: 13)))),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          )
      ],
    );
  }

  Future<dynamic> showMenuDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: AlertDialog(
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
                SizedBox(
                  height: 40,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "추가 설명",
                      style: TextStyle(fontFamily: "Mainfonts", fontSize: 16),
                    )),
                SizedBox(
                  height: 5,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "십시일반 식사 제공시 구체적으로\n어떤 음식을 10% 덜 제공할 예정인지 설명해주세요",
                      style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 13,
                          color: MyColor.GRAY),
                    )),
                SizedBox(
                  height: 7,
                ),
                TextField(
                  controller: menuexplain,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), isDense: true),
                ),
              ]),
              actions: [
                TextButton(
                    onPressed: () {
                      menuname.text = "";
                      menuprice.text = "";
                      menuexplain.text = "";
                      Navigator.pop(context);
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
                    setState(() {
                      final itemName = menuname.text;
                      final itemPrice = menuprice.text;
                      final itemExplanation = menuexplain.text;

                      if (itemName.isNotEmpty &&
                          itemPrice.isNotEmpty &&
                          itemExplanation.isNotEmpty) {
                        NewMenu newItem = NewMenu(
                            menuname: itemName,
                            menuprice: itemPrice,
                            menuexplain: itemExplanation);
                        menuItems.add(newItem);
                      }
                    });

                    menuname.text = "";
                    menuprice.text = "";
                    menuexplain.text = "";
                    Navigator.pop(context);
                  },
                  child: Text("추가하기",
                      style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 16,
                          color: Colors.black)),
                )
              ],
            ),
          );
        });
  }

  Future<dynamic> showMenuUpdateDialog(BuildContext context, String menu,
      String price, String explain, int index) async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
              child: AlertDialog(
            title: const Text(
              "메뉴 수정하기",
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
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: menu),
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
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: price),
              ),
              SizedBox(
                height: 40,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "추가 설명",
                    style: TextStyle(fontFamily: "Mainfonts", fontSize: 16),
                  )),
              SizedBox(
                height: 5,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "십시일반 식사 제공시 구체적으로\n어떤 음식을 10% 덜 제공할 예정인지 설명해주세요",
                    style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 13,
                        color: MyColor.GRAY),
                  )),
              SizedBox(
                height: 7,
              ),
              TextField(
                controller: menuexplain,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: explain),
              ),
            ]),
            actions: [
              TextButton(
                  onPressed: () {
                    menuname.text = "";
                    menuprice.text = "";
                    menuexplain.text = "";
                    Navigator.pop(context);
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
                  setState(() {
                    String itemName = menu;
                    String itemPrice = price;
                    String itemExplanation = explain;

                    if (menuname.text != '') itemName = menuname.text;
                    if (menuprice.text != '') itemPrice = menuprice.text;
                    if (menuexplain.text != '')
                      itemExplanation = menuexplain.text;

                    if (itemName.isNotEmpty &&
                        itemPrice.isNotEmpty &&
                        itemExplanation.isNotEmpty) {
                      NewMenu newItem = NewMenu(
                        menuname: itemName,
                        menuprice: itemPrice,
                        menuexplain: itemExplanation,
                      );

                      menuItems.removeAt(index);
                      menuItems.insert(index, newItem);
                    }
                  });
                  menuname.text = "";
                  menuprice.text = "";
                  menuexplain.text = "";
                  Navigator.pop(context);
                  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  //     builder: (BuildContext context) =>
                  //         RestaurantInfoRegister()), (route) => false);
                },
                child: Text("수정하기",
                    style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 16,
                        color: Colors.black)),
              )
            ],
          ));
        });
  }
}

class NewMenu {
  late String menuname;
  late String menuprice;
  late String menuexplain;

  NewMenu(
      {required String menuname,
      required String menuprice,
      required String menuexplain}) {
    this.menuname = menuname;
    this.menuprice = menuprice;
    this.menuexplain = menuexplain;
  }
}
