import 'dart:math';

import 'package:chipin/child_main/ChildMain.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chipin/base_appbar.dart';
import '../colors.dart';
import '../core/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CustomPricePage extends StatefulWidget {
  final String ownerId;
  CustomPricePage({
    required this.ownerId,
  });

  @override
  _CustomPricePageState createState() => _CustomPricePageState(ownerId: ownerId);
}

class _CustomPricePageState extends State<CustomPricePage> {
  final String colName = "Child";
  final String email = "child@test.com";
  String enteredNumber = '';
  String randomCode = '';
  String uid ="";
  bool codeGenerated = false;

  late String _ownerId = "";
  _CustomPricePageState({
    required String ownerId,
}) {
    _ownerId = ownerId;
  }
  int get maxRegister => 10000;
  bool idInReservation = false;


  void generateRandomCode() {
    final random = Random();
    const int codeLength = 4;
    const String chars = '0123456789abcdefghijklmnopqrstuvwxyz';

    String code = '';
    for (int i = 0; i < codeLength; i++) {
      final index = random.nextInt(chars.length);
      code += chars[index];
    }

    randomCode = code;
    setState(() {
      codeGenerated = true;
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
        // 입력값이 maxRegister보다 크지 않은 경우에만 입력 처리
        int newAmount = int.parse(enteredNumber + key);
        if (newAmount <= maxRegister) {
          enteredNumber += key;
        }
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
      return enteredAmount > 0 && enteredAmount <= (maxRegister ?? 0);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // readData();

    if (idInReservation == true) {
      showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("알림"),
            content: Text("예약이 안됩니다."),
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  // AlertDialog를 닫고 화면을 나감
                  Navigator.of(context).pop();
                  // 화면을 나가려면 다음 줄을 사용 (화면을 나갈 화면이 없으면 뒤로가기와 같음)
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BaseAppBar(title: "가게정보"),
      body: SizedBox(
        width: mediaQueryData.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(26, 27, 22, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: getPadding(
                          left: 1
                      ),
                        child: const Text(
                          "오양칼국수",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: "Mainfonts",
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 2),
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
                                "충남 보령시 보령남로 125-7",
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

              enteredNumber.isNotEmpty ? '$enteredNumber 원' : '얼마를 예약할까요?',
              style: TextStyle(
                  fontFamily: "Pretendard",
                  color: enteredNumber.isNotEmpty ? Colors.black : Colors.grey,
                  fontSize: 28,
                  fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,

            ),
            Padding(padding: const EdgeInsets.only(top: 21),
              child: RichText(
                text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "최대 예약 가능 금액 ",
                        style: TextStyle(fontFamily: "Pretendard",
                            color: Colors.blueGrey,
                            fontSize: 18),
                      ),
                      TextSpan(
                        text: "$maxRegister원",
                        style: const TextStyle(fontFamily: "Pretendard",
                            color: MyColor.DARK_YELLOW,
                            fontSize: 18),
                      )
                    ]

                ),
                textAlign: TextAlign.left,

              ),
            ),

            const SizedBox(height: 55),

            ElevatedButton(
              onPressed: isAmountValid ? _showConfirmationDialog : null,
              // onPressed: () => _showConfirmationDialog(),
              style: ButtonStyle(

                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.resolveWith<Color>((
                    states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey; // 비활성화 상태일 때 회색 배경색
                  }
                  return MyColor.DARK_YELLOW; // 활성화 상태일 때 파란 배경색
                }),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      // side: BorderSide(color: Colors.red)
                    )

                ),

                fixedSize: MaterialStateProperty.all<Size>(
                  Size(MediaQuery
                      .of(context)
                      .size
                      .width - 32, 48), // 가로 길이를 화면 가로 길이 - 32로 설정
                ),
              ),

              child: const Text("예약 확정하기",
                style: TextStyle(fontFamily: "Pretendard",
                    color: Colors.black,
                    fontSize: 20),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,),

            ),


            SizedBox(height: 2),

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
        style: (
            TextButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: MyColor.GRAY
            )
        ),
        child: Text(label,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(fontFamily: "GyeonggiTitleB",
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
              Icon(Icons.check_circle_rounded, color: MyColor.ALERT,),
              SizedBox(width: 8),
              Text('주의사항',
                style: TextStyle(color: MyColor.ALERT,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w500),),
            ],
          ),
          content: const Text(
              '예약 확정 후 1시간 내에 식사하세요!\n1시간 내에 사용하지 않으면 예약이 자동 취소됩니다.',
              style: TextStyle(
                  fontFamily: "Pretendard", fontWeight: FontWeight.w500)
          ),
          actions: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Colors.black), // 검정색 스트로크 추가
                  ),
                  child: const Text('뒤로가기',
                    style: TextStyle(fontFamily: "Pretendard",
                        color: Colors.black,
                        fontWeight: FontWeight.w600),),
                ),
                const SizedBox(width: 25), // 버튼 사이 간격
                TextButton(
                  onPressed: () async {
                    // 랜덤 코드 생성
                    generateRandomCode();

                    // Firebase Firestore에 예약 정보 저장
                    await saveReservationData();

                    Navigator.of(context).pop(true);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: MyColor.DARK_YELLOW, // 배경색 노란색으로 설정
                  ),
                  child: const Text('예약 확정',
                    style: TextStyle(fontFamily: "Pretendard",
                        color: Colors.white,
                        fontWeight: FontWeight.w600),),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // 예약 확정 처리 완료 후 팝업 표시
      _showReservationCompletePopup();

      // 예약 확정 처리 완료 후 메인 화면으로 이동
      Navigator.of(context).pop();

      // 예약 완료 팝업이 닫힌 후 메인 화면으로 이동
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ChildMain(), // 이동할 화면
      ));
    }
  }
  void _showReservationCompletePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('예약 완료'),
          content: Text('예약이 성공적으로 완료되었습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
  Future<void> saveReservationData() async {
    try {
      final db = FirebaseFirestore.instance;
      // final user = FirebaseAuth.instance.currentUser;
      //   String reservationId = FirebaseFirestore.instance.collection('Child').doc().id;
      // if (user != null) {
        // String uid = user.uid;
        await db.collection('Child').doc(email).collection('ReservationInfo').doc(randomCode).set({
          'restaurantId' : _ownerId,
          // 'isCancelled' : false,
          'reservationPrice' : int.parse(enteredNumber),
          'ReservationCode' : randomCode,
          'reservationDate' : FieldValue.serverTimestamp(),
        });
        await db.collection('DiscountCode').doc(randomCode).set({
          'isValid' : false,
          'isUsed' : false
        });

        //idInReservation
        await db.collection(colName).doc(email).update({'idInReservation': true});

      }
    // }
    catch(e) {
      print('예약 정보 저장 중 오류 발생: $e');
    }
  }


}
