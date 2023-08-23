import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base_appbar.dart';
import '../base_shadow.dart';
import '../colors.dart';
import '../restaurant_main/restaurant_splitbutton.dart';
import 'client_receipt_auth.dart';

class ClientMain extends StatefulWidget {
  const ClientMain({Key? key}) : super(key: key);

  @override
  State<ClientMain> createState() => _ClientMainState();
}

class _ClientMainState extends State<ClientMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: BaseAppBar(title: "십시일반"),
        body: Container(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 30, 200, 0),
                    child: TextButton(
                        onPressed: (){},
                        child: Container(
                            child: Row(
                              children: [
                                Image(
                                    width: 20.0,
                                    height: 20.0,
                                    image: AssetImage('assets/images/present.png')
                                ),
                                Container(
                                  width: 10,
                                ),
                                Text(
                                    '이달의 리워드',
                                    style: TextStyle(
                                        fontFamily: "Mainfonts",
                                        fontSize: 20,
                                        color: Colors.black)
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
                              ],
                            )
                        )
                    ),
                  ),
                  BaseShadow(
                    container: Column(
                      children: [
                        Container(
                            height: 50,
                            child: SplitButton(
                                subject: Text(
                                  "누적 후원 포인트",
                                  style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                variance: Text("60,500P",
                                    style: TextStyle(
                                        fontFamily: "Mainfonts",
                                        fontSize: 20,
                                        color: Colors.black)),
                                topLeftRadius: 10,
                                topRightRadius: 10,
                                bottomLeftRadius: 0,
                                bottomRightRadius: 0,
                                onPressed: () { })),
                        Container(
                          height: 1,
                          width: double.maxFinite,
                          color: MyColor.DIVIDER,
                        ),
                        Container(
                            height: 50,
                            child: SplitButton(
                                subject: Text("누적 후원 횟수",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                                variance: Text("23번",
                                    style: TextStyle(
                                        fontFamily: "Mainfonts",
                                        fontSize: 20,
                                        color: Colors.black)),
                                topLeftRadius: 0,
                                topRightRadius: 0,
                                bottomLeftRadius: 10,
                                bottomRightRadius: 10,
                                onPressed: () {})),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const ClientReceiptAuth())
                        );
                      },
                      child: Container(
                        height: 150,
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Image(
                                  width: 20.0,
                                  height: 20.0,
                                  image: AssetImage('assets/images/receipt.png')
                              ),
                              flex: 3,
                            ),
                            Expanded(
                              child: Text(
                                  '영수증 인증하기',
                                  style: TextStyle(
                                      fontFamily: "Mainfonts",
                                      fontSize: 20,
                                      color: Colors.black)
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Container(
                        height: 150,
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Image(
                                  width: 20.0,
                                  height: 20.0,
                                  image: AssetImage('assets/images/map.png')
                              ),
                              flex: 3,
                            ),
                            Expanded(
                              child: Text(
                                  '가맹점 확인하기',
                                  style: TextStyle(
                                      fontFamily: "Mainfonts",
                                      fontSize: 20,
                                      color: Colors.black)
                              ),
                            )
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}