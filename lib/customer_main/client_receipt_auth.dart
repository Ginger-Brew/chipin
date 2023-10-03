import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_appbar.dart';
import '../colors.dart';
import 'client_menu_unit.dart';

class ClientReceiptAuth extends StatefulWidget {
  String title;
  DateTime? date;
  TimeOfDay time;
  List menu;

  ClientReceiptAuth({
    Key? key,
    required this.title,
    required this.date,
    required this.time,
    required this.menu,
  }) : super(key: key);

  @override
  State<ClientReceiptAuth> createState() => _ClientReceiptAuthState(title, date, time, menu);
}

class _ClientReceiptAuthState extends State<ClientReceiptAuth> {
  var title, date, time, menu;
  _ClientReceiptAuthState(this.title, this.date, this.time, this.menu);

  var result = [];
  var image, addr;

  getData() async {
    await FirebaseFirestore.instance
        .collection('Restaurant')
        .snapshots()
        .listen((data) async {
      result.clear();

      for (var element in data.docs) {
        if(element["name"] == title) {
          image = await element["banner"];
          addr = await element["address1"]+' '+element["address2"];
        }
      }

      if(image == null) {
        image = 'https://firebasestorage.googleapis.com/v0/b/chipin-c3559.appspot.com/o'
            '/support%2F%EC%B4%88%EB%A1%9D%EC%9A%B0%EC%82%B0.png?alt=media&token=d0a55dba-e01c-421c-a314-25dde8ffbd0c';
        addr = '데이터업다';
      }
      print(addr);
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: BaseAppBar(title: "가게 정보"),
        body: Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image(
                      width: 400.0,
                      height: 250.0,
                      image: Image.network(image).image
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Text(
                            title,
                            style: TextStyle(
                              fontFamily: "Mainfonts",
                              fontSize: 25,
                              color: Colors.black,)
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Text(
                            addr,
                            style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 15,
                                color: Colors.black)
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 1,
                  width: double.maxFinite,
                  color: MyColor.DIVIDER,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: double.infinity,
                  child: Text(
                      '내가 먹은 메뉴',
                      style: TextStyle(
                        fontFamily: "Mainfonts",
                        fontSize: 20,
                        color: Colors.black,),
                    textAlign: TextAlign.left,
                  ),
                ),
                ClientMenuUnit(title: menu[0], prize: menu[1]+'원', count: menu[2]+'개',),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 10, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text(
                            '후원 되는 포인트',
                            style: TextStyle(
                              fontFamily: "Mainfonts",
                              fontSize: 17,
                              color: Colors.black,)
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                            Point(),
                            style: TextStyle(
                              fontFamily: "Mainfonts",
                              fontSize: 17,
                              color: Colors.black,)
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 20, 0, 10),
                        child: Text(
                            '입력된 정보가 정확한가요?',
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 12,
                              color: Colors.black,),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextButton(
                                    onPressed: () {},
                                    child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.circular(15.0)
                                      ),
                                      child: Text(
                                          '다시 찍기',
                                          style: TextStyle(
                                            fontFamily: "Mainfonts",
                                            fontSize: 17,
                                            color: Colors.white,),
                                          textAlign: TextAlign.center
                                      ),
                                    )
                                )
                            ),
                            Expanded(
                                child: TextButton(
                                    onPressed: () {},
                                    child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.circular(15.0)
                                      ),
                                      child: Text(
                                          '확인',
                                          style: TextStyle(
                                            fontFamily: "Mainfonts",
                                            fontSize: 17,
                                            color: Colors.white,),
                                          textAlign: TextAlign.center
                                      ),
                                    )
                                )
                            )
                          ],
                        )
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  String Point() {
    int prize = int.parse(menu[1]);
    int count = int.parse(menu[2]);
    int result = (prize*count)~/10;

    return result.toString()+"원";
  }

  Widget restaurant_addr() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(40, 20, 0, 0),
      child: Text(
          addr,
          style: TextStyle(
              fontFamily: "Pretendard",
              fontSize: 17,
              color: Colors.black)
      ),
    );
  }
}