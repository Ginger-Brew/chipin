import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../colors.dart';
import '../base_appbar.dart';
import 'package:kpostal/kpostal.dart';
import '../base_button.dart';
import 'package:chipin/restaurant_main/RestaurantMain.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/utils/size_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../restaurant_appbar/RestaurantAppBar.dart';
import '../restaurant_appbar/RestaurantDrawerMenu.dart';

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

List<NewMenu> menuItems = [];
int menuCount = 0;

class RestaurantInfoCorrection extends StatefulWidget {
  const RestaurantInfoCorrection({Key? key}) : super(key: key);

  @override
  State<RestaurantInfoCorrection> createState() =>
      _RestaurantInfoCorrectionState();
}

class _RestaurantInfoCorrectionState extends State<RestaurantInfoCorrection> {
  //firestore에 저장할 때 사용할 컬렉션 이름과 도큐먼트 이름
  final String colName = "Restaurant";
  String beResult = "-를 제외한 10자리 숫자만 입력해주세요";

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
  // XFile pickedImg = XFile('');
  File? testimage;


  // String postCode = '-';
  String address1 = "-";
  String latitude = '-';
  String longitude = '-';

  bool isValidBsNum = false;

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

  void readMenuData() async {
    User? currentUser = getUser();
    menuItems = [];

    if (currentUser != null) {
      final db =
          FirebaseFirestore.instance.collection(colName).doc(currentUser.email);

      try {
        final queryEarnSnapshot = await db.collection("Menu").get();

        if (queryEarnSnapshot.docs.isNotEmpty) {
          debugPrint("debug : 시발 찾았어요오옹~");
          for (var docSnapshot in queryEarnSnapshot.docs) {
            debugPrint("debug : ${docSnapshot['name']}");

            NewMenu newItem = NewMenu(
                menuname: docSnapshot['name'],
                menuprice: docSnapshot['price'],
                menuexplain: docSnapshot['explain']);

            setState(() {
              menuItems.add(newItem);
            });
          }

          debugPrint('menuItem 길이 '+'${menuItems.length}');
        } else {
          debugPrint("debug : 시발 못찾았어용오오오옹~");
        }
      } catch (e) {
        print("Error completing: $e");
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('로그인 정보가 유효하지 않습니다')));
    }
  }

  void readdata() async {
    User? currentUser = getUser();

    if (currentUser != null) {
      final db =
          FirebaseFirestore.instance.collection(colName).doc(currentUser.email);

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
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('로그인 정보가 유효하지 않습니다')));
    }
  }

  bool isPresentBSNum() {
    if (_newRestaurantBusinessNumber.text != "") {
      return true;
    } else {
      return false;
    }
  }

  void updatedata() async {
    User? currentUser = getUser();

    if (currentUser != null) {
      final db =
          FirebaseFirestore.instance.collection(colName).doc(currentUser.email);

      final Reference storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
      final UploadTask uploadTask = storageRef.putFile(testimage!);

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      final String downloadURL = await snapshot.ref.getDownloadURL();

        if (_newRestaurantName.text != "") name = _newRestaurantName.text;
        if (_newRestaurantOpenHour.text != "")
          openH = _newRestaurantOpenHour.text;
        if (_newRestaurantOpenMinute.text != "")
          openM = _newRestaurantOpenMinute.text;
        if (_newRestaurantCloseHour.text != "")
          closeH = _newRestaurantCloseHour.text;
        if (_newRestaurantCloseMinute.text != "")
          closeM = _newRestaurantCloseMinute.text;
        if (_newRestaurantLocation.text != "")
          address2 = _newRestaurantLocation.text;
        if (_newRestaurantClosedday.text != "")
          closeddays = _newRestaurantClosedday.text;
        if (_newRestaurantPhone.text != "") phone = _newRestaurantPhone.text;

        await db
            .update({
              'name': name,
              'address1': this.address1,
              'address2': address2,
              'openH': openH,
              'openM': openM,
              'closeH': closeH,
              'closeM': closeM,
              'closeddays': closeddays,
              'businessnumber': _newRestaurantBusinessNumber.text,
              'phone': phone,
              'banner': pickedImgPath
            })
            .then((value) => print("document added")) // firestore에 저장이 잘 된 경우
            .catchError((error) => print("Fail to add doc ${error}"));
        pickedImgPath = ""; // 변수 초기화

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('가게 정보가 수정되었습니다')));
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
    }
  }

  Future pickImg() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image;
    final status = await Permission.storage.request();
    if (status.isGranted) {
      image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          pickedImgPath = image!.path;
          testimage = File(pickedImgPath);
          // pickedImg = image;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('가게 대표 이미지를 선택해주세요')));
      }
    }
    else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('가게 대표 이미지가 기본 이미지로 설정됩니다')));


    }

  }
  @override
  void initState() {
    super.initState();
    readMenuData();
    readdata();

    debugPrint('$menuItems.length');

    for (int i = 0; i < menuItems.length; i++) {
      print(menuItems[i].menuname);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const RestaurantAppBar(title: '가게 정보 수정하기'),
        endDrawer: RestaurantDrawerMenu(),
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
                RestaurantName(controller: _newRestaurantName, hint: name),
                SizedBox(height: 20),
                RestaurantPhone(controller: _newRestaurantPhone, hint: phone),
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
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
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
                  openHhint: openH,
                  openMhint: openM,
                  closeHhint: closeH,
                  closeMhint: closeM,
                ),
                SizedBox(height: 20),
                RestaurantClosedDay(
                    controller: _newRestaurantClosedday, hint: closeddays),
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
                  if (pickedImgPath != "")
                    Container(
                      width: 150, // Set the desired width
                      height: 100, // Set the desired height
                      child: Image.network(
                        pickedImgPath,
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

                        if(isPresentBSNum()) {
                          updatedata();
                          for (int i = 0; i < menuItems.length; i++) {
                            writemenudata(menuItems[i].menuname,
                                menuItems[i].menuprice,
                                menuItems[i].menuexplain);
                          }
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (
                                      context) => const RestaurantMain()));
                        }
                        else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('사업자 등록 번호는 필수 입력 값입니다')));
                        }})
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

  const RestaurantName({Key? key, required this.controller, required this.hint})
      : super(key: key);

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
          decoration: InputDecoration(
              border: OutlineInputBorder(), isDense: true, hintText: hint),
        )
      ],
    );
  }
}

class RestaurantPhone extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const RestaurantPhone(
      {Key? key, required this.controller, required this.hint})
      : super(key: key);

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
            decoration: InputDecoration(
                border: OutlineInputBorder(), isDense: true, hintText: hint),
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
      required this.closeMhint})
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
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                hintText: openHhint),
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
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                hintText: openMhint),
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
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              hintText: closeHhint),
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
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              hintText: closeMhint),
        )),
      ]),
    ]);
  }
}

class RestaurantClosedDay extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const RestaurantClosedDay(
      {Key? key, required this.controller, required this.hint})
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
        decoration: InputDecoration(
            border: OutlineInputBorder(), isDense: true, hintText: hint),
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
      children: <Widget>[
        Align(
            alignment: Alignment.centerLeft,
            child: Text('메뉴',
                style: TextStyle(fontSize: 16, fontFamily: "Mainfonts"))),
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
                  title: Container(
                    width:  (mediaQueryData.size.width-50) / 2,
                    child: Text(
                      menuItems[index].menuname,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  subtitle: Container(
                    width: (mediaQueryData.size.width-50)/2,
                    child: Text(menuItems[index].menuexplain,
                        style:TextStyle(color: MyColor.GRAY, fontSize: 13)),
                  ),
                  trailing: Container(
                    width: 150,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 70,
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
