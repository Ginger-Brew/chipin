import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chipin/base_appbar.dart';
import 'package:flutter/services.dart';
import '../colors.dart';
import '../core/utils/size_utils.dart';
import '../restaurant_main/RestaurantMain.dart';

class RestaurantPayment extends StatefulWidget {
  final int payment;

  const RestaurantPayment(this.payment);

  @override
  _RestaurantPaymentState createState() => _RestaurantPaymentState();
}

class _RestaurantPaymentState extends State<RestaurantPayment> {
  List<TextEditingController> controllers =
  List.generate(4, (index) => TextEditingController());
  List<FocusNode> focusNodes =
  List.generate(4, (index) => FocusNode()); // Add this line
  List<String> result = List.generate(4, (index) => '');

  //firestore에 저장할 때 사용할 컬렉션 이름과 도큐먼트 이름
  final String colName = "Restaurant";
  final String subColName = "RedeemList";
  final String id = "jdh33114";
  String name = "";
  String address1 = "-";
  String address2 = "";


  bool get isCodeValid {
    if (result.join().length == 4) {
      return true;
    } else {
      return false;
    }
  }

  void readdata() async {
    final readdb = FirebaseFirestore.instance.collection(colName).doc(id);

    await readdb.get().then((DocumentSnapshot ds) {
      Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

      setState(() {
        name = data['name'];
        address1 = data['address1'];
        address2 = data['address2'];


      });
    });
  }




  @override
  void initState() {
    super.initState();
    // Add listeners to each controller
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.length == 1) {
          result[i] = controllers[i].text;
          if (i < controllers.length - 1) {
            FocusScope.of(context)
                .requestFocus(focusNodes[i + 1]); // Change this line
          } else {
            // Reached the last field, do something
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      // Add this loop
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BaseAppBar(title: "할인 코드 직원 확인"),
      body: Container(
          width: mediaQueryData.size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 27, 22, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: getPadding(left: 1),
                            child:  Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: "Mainfonts",
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.black,
                                  size: 19,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text(
                                    address1+" "+address2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  '십시일반 포인트 차감 후\n실결제 금액은',
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      color: Colors.grey,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  widget.payment.toString(),
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      color: Colors.grey,
                      fontSize: 36,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  // onPressed: isCodeValid ? () => Navigator.push(context, MaterialPageRoute(
                  //     builder: (context) =>  RestaurantDiscount())) : null,
                  // onPressed: isCodeValid ? () => writedata() : null,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>  RestaurantMain())),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                      return MyColor.DARK_YELLOW; // 활성화 상태일 때 파란 배경색
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          // side: BorderSide(color: Colors.red)
                        )),
                    fixedSize: MaterialStateProperty.all<Size>(
                      Size(MediaQuery.of(context).size.width - 32,
                          48), // 가로 길이를 화면 가로 길이 - 32로 설정
                    ),
                  ),

                  child: const Text(
                    "확인",
                    style: TextStyle(
                        fontFamily: "Mainfonts",
                        color: Colors.white,
                        fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
