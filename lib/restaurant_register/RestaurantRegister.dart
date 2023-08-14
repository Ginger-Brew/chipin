import 'package:chipin/colors.dart';
import 'package:chipin/restaurant_main/RestaurantMain.dart';
import 'package:flutter/material.dart';
import 'package:chipin/base_appbar.dart';
import 'package:flutter/services.dart';
import 'restaurant_register_component.dart';
import 'package:chipin/base_button.dart';
import '../base_time_picker.dart';

class RestaurantRegister extends StatefulWidget {
  const RestaurantRegister({Key? key}) : super(key: key);

  @override
  State<RestaurantRegister> createState() => _RestaurantRegisterState();
}

class _RestaurantRegisterState extends State<RestaurantRegister> {
  final TextEditingController menuname = TextEditingController();
  final TextEditingController menuprice = TextEditingController();
  // final SPHelper helper = SPHelper();

  bool _menuIsRegistered = false;

  // @override
  // void initState() {
  //   helper.init();
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BaseAppBar(title: '가게 정보 등록하기'),
        body: Container(
          color: MyColor.BACKGROUND,
          padding: EdgeInsets.symmetric(
            horizontal: 31,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 50),
                const RestaurantRegisterComponent(
                    subject: Text('상호',
                        style:
                        TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
                    form: TextField()),
                const SizedBox(height: 50),
                RestaurantRegisterComponent(
                    subject: Text('유선전화',
                        style:
                        TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
                    form: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ])),
                const SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    Container(
                        width: 70,
                        child: Text('주소',
                            style: TextStyle(
                                fontSize: 16, fontFamily: "Mainfonts"))),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        children: [
                          RestaurantRegisterComponent(
                              subject: Text('광역시/도'), form: TextField()),
                          RestaurantRegisterComponent(
                              subject: Text('시/군/구'), form: TextField()),
                          RestaurantRegisterComponent(
                              subject: Text('도로명'), form: TextField()),
                          RestaurantRegisterComponent(
                              subject: Text('상세 주소'), form: TextField())
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    Container(
                      width: 70,
                      child: Text(
                        '영업 시간',
                        style: TextStyle(fontSize: 16, fontFamily: "Mainfonts"),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: <Widget>[
                          TimePickerExample(),
                          SizedBox(width: 10),
                          Text(":",
                              style: TextStyle(
                                  fontSize: 16, fontFamily: "Mainfonts")),
                          SizedBox(width: 10),
                          TimePickerExample(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                RestaurantRegisterComponent(
                    subject: Text('휴무일',
                        style:
                        TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
                    form: TextField()),
                SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    Expanded(flex:1,child: Text('사업자\n등록 번호',
                        style:
                        TextStyle(fontSize: 16, fontFamily: "Mainfonts"))),

                    Expanded(flex:5,child: Column(children : [BaseButton(text: "파일 첨부", fontsize: 13, onPressed: (){},)
                    ]))],
                ),
                SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    Expanded(flex:1,child:Text('메뉴',
                        style:
                        TextStyle(fontSize: 16, fontFamily: "Mainfonts")),
                    ),
                    Expanded(flex : 5,child:Column(
                      children: [
                         BaseButton(
                          text: "메뉴 추가",
                          fontsize: 13,
                          onPressed: () => showMenuDialog(context),
                        ),
                        ],)
                    )
                  ],
                ),
                SizedBox(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  BaseButton(
                    text: "등록",
                    fontsize: 16,
                    onPressed: () =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RestaurantMain())),
                  )
                ]),
                SizedBox(height: 50),
              ],
            ),
          ),
        ));
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
                decoration:
                InputDecoration(border: OutlineInputBorder(), isDense: true),
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
                decoration:
                InputDecoration(border: OutlineInputBorder(), isDense: true),
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
                    style: TextStyle(fontSize: 16, fontFamily: "Pretendard",color: Colors.black),
                  )),
              ElevatedButton(
                onPressed: () {
                  menuprice.text = "";
                  menuname.text = "";
                  Navigator.pop(context);
                },
                child: Text("추가하기",
                    style: TextStyle(fontFamily: "Pretendard", fontSize: 16,color: Colors.black)),
              )
            ],
          );
        });
  }
}
