import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chipin/base_appbar.dart';
import 'package:flutter/services.dart';
import '../colors.dart';
import '../core/utils/size_utils.dart';

class RestaurantDiscount extends StatefulWidget {
  @override
  _RestaurantDiscountState createState() => _RestaurantDiscountState();
}

class _RestaurantDiscountState extends State<RestaurantDiscount> {
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


  void writedata() async {
    final db = FirebaseFirestore.instance;

    db
        .collection("Child")
        .doc("tlqkftlqk@naver.com")
        .collection("ReservationInfo")
        .doc(result.join())
        .get()
        .then((DocumentSnapshot ds) {
      Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

      int reservationprice = data['price'];
    });

    // firestore에 저장
    await db
        .collection(colName)
        .doc(id)
        .collection(subColName)
        .doc(subColName)
        .set({'discountcode': "adf"})
        .then((value) => print("document added")) // firestore에 저장이 잘 된 경우
        .catchError((error) => print("Fail to add doc ${error}"));
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

    List<Widget> textFields = controllers.asMap().entries.map((entry) {
      int index = entry.key;
      TextEditingController controller = entry.value;
      FocusNode focusNode =
          focusNodes[index]; // Get the corresponding focus node

      return Container(
        margin: EdgeInsets.all(10.0),
        width: 50.0,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          // Assign the focus node
          maxLength: 1,
          buildCounter: (BuildContext context,
                  {int? currentLength, int? maxLength, bool? isFocused}) =>
              null,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.text,
          decoration:
              InputDecoration(border: OutlineInputBorder(), isDense: true),
          textInputAction: index == controllers.length - 1
              ? TextInputAction.done // Set Done for the last text field
              : TextInputAction.next,
          // Set Next for the rest of the fields
          onSubmitted: (value) {
            if (index < controllers.length - 1) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            } else {
              // Reached the last field, do something
            }
          },
        ),
      );
    }).toList();
    readdata();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BaseAppBar(title: "가게정보"),
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
                  '할인 코드를 입력해주세요',
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      color: Colors.grey,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: textFields,
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  // onPressed: isCodeValid ? () => Navigator.push(context, MaterialPageRoute(
                  //     builder: (context) =>  RestaurantDiscount())) : null,
                  onPressed: isCodeValid ? () => writedata() : null,
                  // onPressed: () => writedata(),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (!isCodeValid) {
                        return Colors.grey; // 비활성화 상태일 때 회색 배경색
                      }
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
