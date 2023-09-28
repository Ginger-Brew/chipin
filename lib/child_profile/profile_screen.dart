import 'package:flutter/material.dart';

import '../../base_appbar.dart';
import '../../colors.dart';
import '../core/utils/size_utils.dart';

class ProfileScreen extends StatelessWidget {
  // const ProfileScreen({Key? key})
  //     : super(
  //         key: key,
  //       );
  late final bool isCardVerified; // 복지카드 인증 여부

  ProfileScreen({required this.isCardVerified});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: BaseAppBar(title: "내 정보"),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: getVerticalSize(
                  127,
                ),
                width: double.maxFinite,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width:
                            MediaQuery.of(context).size.width, // 화면 가로 길이로 설정
                        padding: getPadding(
                          left: 156,
                          top: 12,
                          right: 156,
                          bottom: 12,
                        ),
                        // decoration: AppDecoration.fill5,
                        child: Padding(
                          padding: getPadding(
                            top: 10,
                          ),
                          child: Text(
                            "아동",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            // style: theme.textTheme.headlineLarge,
                          ),
                        ),
                      ),
                    ),
                    // CustomImageView(
                    //   imagePath: ImageConstant.imgUnsplashjmurdhtm7ng,
                    //   height: getSize(
                    //     122,
                    //   ),
                    //   width: getSize(
                    //     122,
                    //   ),
                    //   radius: BorderRadius.circular(
                    //     getHorizontalSize(
                    //       61,
                    //     ),
                    //   ),
                    //   alignment: Alignment.centerLeft,
                    //   margin: getMargin(
                    //     left: 21,
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: getPadding(
                          right: 190,
                          bottom: 33,
                        ),
                        child: Text(
                          "옹심이",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          // style:
                          //     CustomTextStyles.titleLargeGyeonggiTitleBPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isCardVerified
                      ? VerifiedCardWidget()
                      : UnverifiedCardWidget(),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "지난 식사 내역 보러가기",
                      style: TextStyle(
                          fontFamily: "Pretendard",
                          color: Colors.black,
                          fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black12,
                    )
                  ],
                ),

                // onPressed: isAmountValid ? _showConfirmationDialog : null,
                onPressed: () {},
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
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
              ),
              Spacer(),
              Text(
                "Terms and Conditions",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                // style: theme.textTheme.labelLarge!.copyWith(
                //   decoration: TextDecoration.underline,
                // ),
              ),
              Padding(
                padding: getPadding(
                  top: 18,
                  bottom: 43,
                ),
                child: Text(
                  "version: 1.0.0",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  // style: CustomTextStyles.bodySmallInterGray600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifiedCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16), // 좌우 마진 추가
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(color: MyColor.DARK_YELLOW, width: 2.0),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: MyColor.DARK_YELLOW,
                ),
                SizedBox(width: 8),
                Text(
                  "복지카드 인증 완료!",
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      color: Colors.black,
                      fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class UnverifiedCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: Row(
            children: [
              Icon(
                Icons.error_outline_rounded, // 알림 아이콘
                color: Colors.red, // 빨간색
              ),
              SizedBox(width: 8), // 아이콘과 텍스트 사이 간격 조절
              Text(
                '복지카드 인증하기',
                style: TextStyle(
                  fontFamily: "Pretendard",
                  color: Colors.black,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),

            ],
          ),
          onPressed: () {},
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red), // 스트로크 색상을 빨간색으로 변경
              ),
            ),
            fixedSize: MaterialStateProperty.all<Size>(
              Size(MediaQuery.of(context).size.width - 32,
                  48), // 가로 길이를 화면 가로 길이 - 32로 설정
            ),
          ),
        ),
      ],
    );
  }
}
