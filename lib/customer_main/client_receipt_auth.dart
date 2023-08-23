import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_appbar.dart';
import '../colors.dart';
import 'client_menu_unit.dart';

class ClientReceiptAuth extends StatefulWidget {
  const ClientReceiptAuth({Key? key}) : super(key: key);

  @override
  State<ClientReceiptAuth> createState() => _ClientReceiptAuthState();
}

class _ClientReceiptAuthState extends State<ClientReceiptAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: BaseAppBar(title: "가게 정보"),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image(
                      width: 400.0,
                      height: 250.0,
                      image: AssetImage('assets/images/ohyang_restaurant.png')
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                            '오양 칼국수',
                            style: TextStyle(
                              fontFamily: "Mainfonts",
                              fontSize: 20,
                              color: Colors.black,)
                        ),
                      ),
                      Container(
                        child: Text(
                            '충남 보령시 보령남로 125-7',
                            style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 17,
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
                  child: Text(
                      '내가 먹은 메뉴',
                      style: TextStyle(
                        fontFamily: "Mainfonts",
                        fontSize: 20,
                        color: Colors.black,)
                  ),
                ),
                ClientMenuUnit(title: '오.칼(보리밥)', prize: '9000원', count: '1개',),
                ClientMenuUnit(title: '키.칼(보리밥)', prize: '8000원', count: '2개',),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
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
                            '2,000원',
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
                    children: [
                      Container(
                        child: Text(
                            '입력된 정보가 정확한가요?',
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 12,
                              color: Colors.black,)
                        ),
                      ),
                      Row(
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
                                        '정보 입력하기',
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
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}