import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:chipin/customer_main/ClientMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../base_appbar.dart';
import '../colors.dart';
import 'client_appbar.dart';
import 'client_drawer_menu.dart';
import 'client_menu_unit.dart';

class ClientReceiptAuth extends StatefulWidget {
  String business_num;
  DateTime? date;
  List menu;
  List a_prize;
  List count;
  String total;

  ClientReceiptAuth({
    Key? key,
    required this.business_num,
    required this.date,
    required this.menu,
    required this.a_prize,
    required this.count,
    required this.total,
  }) : super(key: key);

  @override
  State<ClientReceiptAuth> createState() => _ClientReceiptAuthState(business_num, date, menu, a_prize, count, total);
}

class _ClientReceiptAuthState extends State<ClientReceiptAuth> {
  var business_num, date, menu, a_prize, count, total;
  _ClientReceiptAuthState(this.business_num, this.date, this.menu, this.a_prize, this.count, this.total);

  var result = [];
  var image, addr, title, restaurantId;
  String? userid = FirebaseAuth.instance.currentUser!.email;
  int _saveIndex = 0;
  var tmpImg = 'https://firebasestorage.googleapis.com/v0/b/chipin-c3559.appspot.com/o/support%2F%EC%B4%88%EB%A1%9D%EC%9A%B0%EC%82%B0.png?alt=media&token=d0a55dba-e01c-421c-a314-25dde8ffbd0c';

  Future<List> getData() async {
    await FirebaseFirestore.instance
        .collection('Restaurant')
        .snapshots()
        .listen((data) async {
      for (var element in data.docs) {

        if(element["businessnumber"] == business_num) {
          restaurantId = element.id;
          result = [element["name"], element["banner"], element["address1"], element["address2"]];
        }
      }
    });

    final usercol=FirebaseFirestore.instance.collection("History").doc(userid);
    final snapshot = await usercol.get();
    if(snapshot.exists) {
      _saveIndex = (snapshot.data() as Map).length;
    }
    print(restaurantId);

    return result;

  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: ClientAppBar(title: "가게 정보"),
        endDrawer: const ClientDrawerMenu(),
        body: Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                            '가게에 등록된 사진이 없습니다.',
                            style: TextStyle(
                                fontFamily: "Mainfonts",
                                fontSize: 15,
                                color: Colors.grey)
                        );
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
                        print(snapshot.data);
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                              width: MediaQuery.sizeOf(context).width,
                              height: 250.0,
                              image: Image.network(snapshot.data![1].toString()).image
                          ),
                        );
                      } else {
                        print("else");
                        return CircularProgressIndicator();
                      }
                    },),
                Container(  // 상호명
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
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
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                              child: Text(
                                  snapshot.data![0].toString(),
                                  style: TextStyle(
                                    fontFamily: "Mainfonts",
                                    fontSize: 25,
                                    color: Colors.black,)
                              ),
                            );
                          } else {
                            print("else");
                            return CircularProgressIndicator();
                          }
                        },
                      ),

                      FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
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
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                              child: Text(
                                  '${snapshot.data![2].toString()} ${snapshot.data![3].toString()}',
                                  style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: 15,
                                      color: Colors.black)
                              ),
                            );
                          } else {
                            print("else");
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
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 5),
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
                listviewBuilder(),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '후원 되는 포인트',
                          style: TextStyle(
                            fontFamily: "Mainfonts",
                            fontSize: 17,
                            color: Colors.black,)
                      ),
                      Text(
                          Point()+"원",
                          style: TextStyle(
                            fontFamily: "Mainfonts",
                            fontSize: 17,
                            color: Colors.black,)
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
                                    onPressed: () {
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
                                          '취소',
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
                                      month = DateFormat('MM').format(date);
                                      day = DateFormat('dd').format(date);
                                      hour = DateFormat('HH').format(date);
                                      minute = DateFormat('mm').format(date);

                                      writeClientHistory(date.year.toString(), month, day, hour, minute, result[0], Point());

                                      writeRestaurantEarnList(date, int.parse(Point()));

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
    var tmp = total.replaceAll(',', '');
    num result = int.parse(tmp)~/10;

    return result.toString();
  }

  writeClientHistory(year, month, day, hour, minute, title, point) {
    FirebaseFirestore.instance.
    collection('History').
    doc(userid).
    update(
        {
          _saveIndex.toString() : [year, month, day, hour, minute, title, point]
        }
    );
  }

  Future<num> calculateTotalPoint() async {
    num earnPoint = 0;
    num redeemPoint = 0;
    final db = FirebaseFirestore.instance.collection("Restaurant").doc(
        restaurantId);

    try {
      final queryEarnSnapshot = await db.collection("EarnList").get();

      if (queryEarnSnapshot.docs.isNotEmpty) {
        for (var docSnapshot in queryEarnSnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          earnPoint += docSnapshot.data()['earnPoint'];
        }
      }
    } catch (e) {
      print("Error completing: $e");
    }

    try {
      final queryEarnSnapshot = await db.collection("RedeemList").get();

      if (queryEarnSnapshot.docs.isNotEmpty) {
        for (var docSnapshot in queryEarnSnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          redeemPoint += docSnapshot.data()['redeemPoint'];
        }
      }
    } catch (e) {
      print("Error completing: $e");
    }

    return earnPoint - redeemPoint;
  }

  writeRestaurantEarnList(DateTime date, num point) async {
    final db = FirebaseFirestore.instance
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("EarnList");

    num sum = await calculateTotalPoint();
    print("sum : $sum");
    await db
        .add({
      'earnDate': date,
      'earnPoint': point,
      'totalPoint': (sum as int) + (point as int)
    })
        .then((value) => print("document added")) // firestore에 저장이 잘 된 경우
        .catchError((error) => print("Fail to add doc ${error}"));

  }

  Widget listviewBuilder() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: menu.length,
        itemBuilder: (context, index) {
          return ClientMenuUnit(
              title: '${menu[index]}',
            prize: '${a_prize[index]}원',
            count: '${count[index]}개',);
        }
    );
  }
}