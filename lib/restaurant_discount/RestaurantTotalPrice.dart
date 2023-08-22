import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chipin/base_appbar.dart';
import '../colors.dart';
import '../core/utils/size_utils.dart';
import 'RestaurantDiscount.dart';

class RestaurantTotalPrice extends StatefulWidget {
  @override
  _RestaurantTotalPriceState createState() => _RestaurantTotalPriceState();
}

class _RestaurantTotalPriceState extends State<RestaurantTotalPrice> {
  String enteredNumber = '';
  final String colName = "Restaurant";
  final String id = "jdh33114";
  String name = "";
  String address1 = "-";
  String address2 = "";

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

  void _onKeyPressed(String key) {
    if (key == '←') {
      // 기존 코드
      if (enteredNumber.isNotEmpty) {
        enteredNumber = enteredNumber.substring(0, enteredNumber.length - 1);
      }
    } else {
      // 입력값이 숫자인지 확인
      if (RegExp(r'^\d+$').hasMatch(key)) {
        enteredNumber += key;
      }
    }
    setState(() {});
  }

  void _onDeletePressed() {
    setState(() {
      if (enteredNumber.isNotEmpty) {
        enteredNumber = enteredNumber.substring(0, enteredNumber.length - 1);
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      enteredNumber = '';
    });
  }

  bool get isAmountValid {
    if (enteredNumber.isNotEmpty) {
      int enteredAmount = int.tryParse(enteredNumber) ?? 0;
      return enteredAmount > 0 ;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    readdata();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BaseAppBar(title: "할인 코드 직원 확인하기"),
      body: SizedBox(
        width: mediaQueryData.size.width,
        height: mediaQueryData.size.height,
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
                        child: Text(
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
                                address1 +" "+address2,
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
            const Spacer(),
            const SizedBox(height: 50),
            Text(
              enteredNumber.isNotEmpty ? '$enteredNumber 원' : '아동이 식사한 총 금액을\n입력해주세요',
              style: TextStyle(
                  fontFamily: "Pretendard",
                  color: enteredNumber.isNotEmpty ? Colors.black : Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: isAmountValid ? () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>  RestaurantDiscount())) : null,
              // onPressed: () => _showConfirmationDialog(),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled)) {
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
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildKeypadButton('1'),
                _buildKeypadButton('2'),
                _buildKeypadButton('3'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildKeypadButton('4'),
                _buildKeypadButton('5'),
                _buildKeypadButton('6'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildKeypadButton('7'),
                _buildKeypadButton('8'),
                _buildKeypadButton('9'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildKeypadButton('00'),
                _buildKeypadButton('0'),
                _buildKeypadButton('←', onPressed: _onDeletePressed)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String label, {Function()? onPressed}) {
    return Padding(
      // padding: EdgeInsets.all(8),
      padding: getPadding(
        left: 25,
        top: 23,
        right: 25,
      ),
      child: TextButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          } else {
            _onKeyPressed(label);
          }
        },
        style: (TextButton.styleFrom(
            backgroundColor: Colors.white, foregroundColor: MyColor.GRAY)),
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontFamily: "GyeonggiTitleB",
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          // style: CustomTextStyles
          //     .bodyLargePrimaryContainer,
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: MyColor.ALERT,
              ),
              SizedBox(width: 8),
              Text(
                '주의사항',
                style: TextStyle(
                    color: MyColor.ALERT,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          content: const Text(
              '예약 확정 후 1시간 내에 식사하세요!\n1시간 내에 사용하지 않으면 예약이 자동 취소됩니다.',
              style: TextStyle(
                  fontFamily: "Pretendard", fontWeight: FontWeight.w500)),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Colors.black), // 검정색 스트로크 추가
                  ),
                  child: const Text(
                    '뒤로가기',
                    style: TextStyle(
                        fontFamily: "Pretendard",
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 25), // 버튼 사이 간격
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    backgroundColor: MyColor.DARK_YELLOW, // 배경색 노란색으로 설정
                  ),
                  child: const Text(
                    '예약 확정',
                    style: TextStyle(
                        fontFamily: "Pretendard",
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // 예약 확정 처리
      // ...
    }
  }
}
