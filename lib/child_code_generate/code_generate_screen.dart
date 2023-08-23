import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../base_appbar.dart';
import '../../colors.dart';
import '../../core/utils/size_utils.dart';

class CodeGenerateScreen extends StatefulWidget {
  const CodeGenerateScreen({super.key});

  @override
  _CodeGenerateScreenState createState() => _CodeGenerateScreenState();
}

class _CodeGenerateScreenState extends State<CodeGenerateScreen> {
  String randomCode = '';
  bool codeGenerated = false;
  int countdownSeconds = 60;
  late Timer countdownTimer;
  bool isTimerRunning = false;
  bool isButtonEnabled = true;

  void generateRandomCode() {
    if (isTimerRunning) {
      return; // 타이머 작동 중일 때는 버튼을 누를 수 없도록 막음
    }
    final random = Random();
    randomCode = random.nextInt(10000).toString().padLeft(4, '0');
    setState(() {
      codeGenerated = true;
      startCountdown();
      isTimerRunning = true;
    });
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdownSeconds--;
      });

      if (countdownSeconds <= 0) {
        timer.cancel();
        resetCountdown();
      }
    });
  }
  void resetCountdown() {
    setState(() {
      countdownSeconds = 60;
      codeGenerated = false;
      isTimerRunning = false;
      isButtonEnabled = true; // 코드 만료 후 버튼 활성화
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("코드 만료"),
            content: const Text("코드가 만료되었습니다."),
            actions: [
              TextButton(
                child: const Text("다시 코드 발급받기"),
                onPressed: () {
                  Navigator.of(context).pop();
                  generateRandomCode();
                },
              ),
            ],
          );
        },
      );
    });


  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        resizeToAvoidBottomInset: false,
        appBar: const BaseAppBar(title: "코드생성"),
        body: SizedBox(
          height: mediaQueryData.size.height,
          width: double.maxFinite,
          child: Container(
            padding: getPadding(
              left: 14,
              right: 14,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2, right: 11, top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 80, // 이미지의 너비 설정 (적절한 값으로 조정)
                          height: 80, // 이미지의 높이 설정 (적절한 값으로 조정)
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/ohyang_restaurant.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          margin: const EdgeInsets.only(left: 21),
                        ),
                        SizedBox(width: 10), // 이미지와 텍스트 사이의 간격
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "현재 예약중!",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "오양칼국수",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "충청남도 보령시 오천면 소성리 691-52",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: getPadding(
                    top: 24,
                  ),
                  child: Divider(
                    height: getVerticalSize(
                      1,
                    ),
                    thickness: getVerticalSize(
                      1,
                    ),
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: isButtonEnabled ? generateRandomCode : null,
                  // onPressed: () {
                  //   generateRandomCode();
                  //   isTimerRunning = true;
                  // },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(
                      codeGenerated ? MyColor.DARK_YELLOW : Colors.white,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        // side: BorderSide(color: Colors.red)
                      ),
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(
                      Size(MediaQuery.of(context).size.width - 32, 48),
                    ),
                  ),
                  child: Text(
                    codeGenerated ? "확인 코드 생성 완료!" : "확인 코드 생성하기",
                    style: const TextStyle(
                        fontFamily: "Pretendard",
                        color: Colors.black,
                        fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),

                Padding(
                  padding: getPadding(
                    left: 83,
                    top: 14,
                    right: 82,
                    bottom: 14,
                  ),
                  child :  Container(
                    padding: const EdgeInsets.all(16),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(10),
                    //   border: Border.all(
                    //     color: codeGenerated ? Colors.grey : Colors.transparent,
                    //   ),
                    // ),
                    child: codeGenerated
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCodeBox(randomCode[0]),
                        _buildCodeBox(randomCode[1]),
                        _buildCodeBox(randomCode[2]),
                        _buildCodeBox(randomCode[3]),
                      ],
                    )
                        : Container(),
                  ),

                  // child: PinCodeTextField(
                  //   appContext: context,
                  //   length: 4,
                  //   obscureText: false,
                  //   obscuringCharacter: '*',
                  //   keyboardType: TextInputType.number,
                  //   autoDismissKeyboard: true,
                  //   enableActiveFill: true,
                  //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  //   onChanged: (value) {},
                  //   controller: TextEditingController(text: randomCode), // Set the generated code
                  //   pinTheme: PinTheme(
                  //     fieldHeight: getHorizontalSize(43),
                  //     fieldWidth: getHorizontalSize(35),
                  //     shape: PinCodeFieldShape.box,
                  //     borderRadius: BorderRadius.circular(getHorizontalSize(5)),
                  //     selectedFillColor: appTheme.background_white_main,
                  //     activeFillColor: appTheme.background_white_main,
                  //     inactiveFillColor: appTheme.background_white_main,
                  //     inactiveColor: appTheme.gray500,
                  //     selectedColor: appTheme.gray500,
                  //     activeColor: appTheme.gray500,
                  //   ),
                  // ),
                ),
                const SizedBox(height: 20),
                isTimerRunning
                    ? Text(
                  "남은 시간: $countdownSeconds 초",
                  style: const TextStyle(fontSize: 16),
                )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCodeBox(String code) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxSize = screenWidth * 0.1; // 스크린 너비의 일부로 박스 크기 조정

    return Container(
      width: boxSize,
      height: boxSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: codeGenerated ? Colors.grey : Colors.transparent,
        ),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontSize: 16,
          // fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}

EdgeInsets getPadding(
    {double? left, double? top, double? right, double? bottom}) {
  return EdgeInsets.fromLTRB(left ?? 0, top ?? 0, right ?? 0, bottom ?? 0);
}

double getHorizontalSize(double size) {
  // Replace this with your size calculation logic
  return size;
}
