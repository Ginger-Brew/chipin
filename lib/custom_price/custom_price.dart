
import 'package:flutter/material.dart';

import '../../base_appbar.dart';
import '../colors.dart';
import '../core/utils/size_utils.dart';

class CustomPricePage extends StatefulWidget {
  @override
  _CustomPricePageState createState() => _CustomPricePageState();
}

class _CustomPricePageState extends State<CustomPricePage> {
  String enteredNumber = '';

  int get maxRegister => 10000;

  void _onKeyPressed(String key) {
    setState(() {
      enteredNumber += key;
    });
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
    if (enteredNumber.isNotEmpty){
      int enteredAmount = int.tryParse(enteredNumber) ?? 0;
      return enteredAmount > 0 && enteredAmount <= (maxRegister ?? 0);
    }
    return false;
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  BaseAppBar(title: "가게정보"),
      body: SizedBox(
        width: mediaQueryData.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: getPadding(
              left: 26,
              top: 27,
              right: 22,
            ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: getPadding(
                        left: 1
                      ),
                        child: Text(
                          "오양칼국수",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                            style: const TextStyle(fontSize:40, fontFamily: "Mainfonts",color: Colors.black)
                        ),
                      ),
                      Padding(padding: getPadding(
                        top: 2
                      ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.black,
                              size: 19,
                            ),

                            Padding(
                              padding: getPadding(
                                left: 4,
                              ),
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
            Spacer(),
            SizedBox(height: 50),

            Text(

              enteredNumber.isNotEmpty ? enteredNumber+' 원' : '얼마를 예약할까요?',
              style: TextStyle(
                  fontFamily: "Pretendard",
                  color: enteredNumber.isNotEmpty ? Colors.black : Colors.grey,
                  fontSize: 28,
                  fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,

            ),
            Padding(padding: getPadding(
              top: 21,
            ),
              child:RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "최대 예약 가능 금액 ",
                      style : TextStyle(fontFamily: "Pretendard",color: Colors.blueGrey, fontSize: 18),
                    ),
                    TextSpan(
                      text: (maxRegister).toString()+"원",
                      style: TextStyle(fontFamily: "Pretendard",color: MyColor.DARK_YELLOW, fontSize: 18),
                    )
                  ]

                ),
                textAlign: TextAlign.left,

              ),
            ),

            SizedBox(height: 100),

            ElevatedButton(

              child: Text("예약 확정하기",
                style: TextStyle(fontFamily: "Pretendard",color: Colors.black, fontSize: 20),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,),
              onPressed: () => _showConfirmationDialog(),
              style: ButtonStyle(

                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
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
              Size(MediaQuery.of(context).size.width - 32, 48), // 가로 길이를 화면 가로 길이 - 32로 설정
    ),
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
        bottom: 30
      ),
      child: TextButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          } else {
            _onKeyPressed(label);
          }

        },
        style:(
        TextButton.styleFrom(
          backgroundColor:  Colors.white, foregroundColor: MyColor.GRAY
        )
        ) ,
        child: Text(label,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(fontFamily: "GyeonggiTitleB", fontSize: 30, color: Colors.black,fontWeight: FontWeight.bold),
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
          title: Row(
            children: [
              Icon(Icons.check_circle_rounded,color: MyColor.ALERT,),
              SizedBox(width: 8),
              Text('주의사항',
                style: TextStyle(color: MyColor.ALERT,fontFamily: "Pretendard",fontWeight: FontWeight.w500),),
            ],
          ),
          content: Text(
              '예약 확정 후 1시간 내에 식사하세요!\n1시간 내에 사용하지 않으면 예약이 자동 취소됩니다.',
              style: TextStyle(fontFamily: "Pretendard",fontWeight: FontWeight.w500)
          ),
          actions: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('뒤로가기',
                    style: TextStyle(fontFamily: "Pretendard",
                        color: Colors.black,
                        fontWeight: FontWeight.w600),),
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.black), // 검정색 스트로크 추가
                  ),
                ),
                SizedBox(width: 25), // 버튼 사이 간격
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('예약 확정',
                    style: TextStyle(fontFamily: "Pretendard",
                        color: Colors.white,
                        fontWeight: FontWeight.w600),),
                  style: TextButton.styleFrom(
                    backgroundColor: MyColor.DARK_YELLOW, // 배경색 노란색으로 설정
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
