import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:chipin/customer_main/ClientMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_appbar.dart';
import '../colors.dart';
import 'client_menu_unit.dart';

class Tuple {
  String item1;
  String item2;

  Tuple(this.item1, this.item2);
}

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
  var image, addr, restaurantId;
  String? userid = FirebaseAuth.instance.currentUser!.email;
  int _saveIndex = 0;
  var tmpImg = 'https://firebasestorage.googleapis.com/v0/b/chipin-c3559.appspot.com/o/support%2F%EC%B4%88%EB%A1%9D%EC%9A%B0%EC%82%B0.png?alt=media&token=d0a55dba-e01c-421c-a314-25dde8ffbd0c';

  Future<Tuple> getData() async {
    await FirebaseFirestore.instance
        .collection('Restaurant')
        .snapshots()
        .listen((data) async {
      for (var element in data.docs) {
        result.clear();

        if(element["name"] == title) {
          restaurantId = element.id;
          result.add([element["name"], element["banner"], element["address1"], element["address2"]]);
        }
      }
    });

    final usercol=FirebaseFirestore.instance.collection("History").doc(userid);
    final snapshot = await usercol.get();
    if(snapshot.exists) {
      _saveIndex = (snapshot.data() as Map).length;
    }
    restaurant_img();
    restaurant_addr();

    print(restaurantId);
    print(image);
    print(addr);

    return image;
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
                FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return CircularProgressIndicator();
                      }
                      else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Error!: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                            style: TextStyle(fontSize: 15),
                          ),
                        );
                      }
                      else if (snapshot.hasData) {
                        print("print!");
                        print(snapshot.data!);
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                              width: 400.0,
                              height: 250.0,
                              image: Image.network(image).image
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },),
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
                      FutureBuilder(
                        future: restaurant_addr(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData == false) {
                            return CircularProgressIndicator();
                          }
                          else if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Error!: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                                style: TextStyle(fontSize: 15),
                              ),
                            );
                          }
                          else if (snapshot.hasData) {
                            print("print!");
                            print(snapshot.data!);
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                              child: Text(
                                  snapshot.data.toString(),
                                  style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: 15,
                                      color: Colors.black)
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
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
                            Point()+"원",
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
                                    onPressed: () {
                                      String month, day, hour, minute;
                                      if(date.month < 10) {
                                        month = "0"+date.month.toString();
                                      } else {
                                        month = date.month.toString();
                                      }
                                      if(date.day < 10) {
                                        day = "0"+date.day.toString();
                                      } else {
                                        day = date.day.toString();
                                      }
                                      if(time.hour < 10) {
                                        hour = "0"+time.hour.toString();
                                      } else {
                                        hour = time.hour.toString();
                                      }
                                      if(time.minute < 10) {
                                        minute = "0"+time.minute.toString();
                                      } else {
                                        minute = time.minute.toString();
                                      }

                                      writeClientHistory(date.year.toString(), month, day, hour, minute, title, Point());

                                      DateTime dt = DateTime.parse("${date.year.toString()}-${month}-${day}T${hour}:${minute}");
                                      writeRestaurantEarnList(dt, int.parse(Point()));

                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => const ClientMain())
                                      );
                                    },
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
    num prize = int.parse(menu[1]);
    num count = int.parse(menu[2]);
    num result = (prize*count)~/10;

    return result.toString();
  }

  restaurant_img()  {
    for(var element in result) {
      if(element[0] == title) {
        image = element[1];
      }
    }
  }

  restaurant_addr() async {
    for(var element in result) {
      if(element[0] == title) {
        return element[2] + " " + element[3];
      }
    }
  }

  writeClientHistory(year, month, day, hour, minute, title, point) {
    FirebaseFirestore.instance.
    collection('History').
    doc(userid).update(
        {
          _saveIndex.toString() : [year, month, day, hour, minute, title, point]
        }
    );
  }

  Future<num> calculateTotalPoint() async {
    num sum = 0;
    await FirebaseFirestore.instance
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("EarnList").snapshots().listen((data) async {
      for (var element in data.docs) {
        sum += element['earnPoint'];
      }
    });
    print('earnListSum: $sum');

    await FirebaseFirestore.instance
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("RedeemList").snapshots().listen((data) async {
      for (var element in data.docs) {
        sum -= element["redeemPoint"];
      }
    });
    print('redeemListSum: $sum');

    return sum;
  }

  writeRestaurantEarnList(DateTime date, num point) async {
    final db = FirebaseFirestore.instance
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("EarnList");

    num sum = 0;
    await db.snapshots().listen((data) async {
      for (var element in data.docs) {
        sum += await element['earnPoint'];
      }
    });
    print('earnListSum: $sum');

    await FirebaseFirestore.instance
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("RedeemList").snapshots().listen((data) async {
      for (var element in data.docs) {
        print(element["redeemPoint"]);
        sum -= await element["redeemPoint"];
      }
    });
    print('redeemListSum: $sum');

    // firestore에 저장
    await db
        .add({
      'earnDate': date,
      'earnPoint': point,
      'totalPoint': sum+point
    })
        .then((value) => print("document added")) // firestore에 저장이 잘 된 경우
        .catchError((error) => print("Fail to add doc ${error}"));

  }
}