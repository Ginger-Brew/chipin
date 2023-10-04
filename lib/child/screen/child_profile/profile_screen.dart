import 'package:chipin/child/screen/child_appbar/ChildAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../core/utils/size_utils.dart';
import '../child_appbar/ChildDrawerMenu.dart';
import '../child_previous_reservation/previous_reservation.dart';


class ProfileScreen extends StatelessWidget {
  final bool isCardVerified; // 복지카드 인증 여부

  const ProfileScreen({super.key, required this.isCardVerified});

  User? getUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final name = user.displayName;
      final email = user.email;
      final photoUrl = user.photoURL;
      final amailVerified = user.emailVerified;
      final uid = user.uid;
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    User? currentUser = getUser();
    String? photoUrl = currentUser?.photoURL;

    Widget profileImage = photoUrl != null
        ? InkWell(
      onTap: () {
        // 프로필 사진을 클릭할 때 실행할 동작 추가
      },
      child: CircleAvatar(
        backgroundImage: NetworkImage(photoUrl),
        radius: 40.0,
      ),
    )
        : InkWell(
      onTap: () {
        // 프로필 사진을 클릭할 때 실행할 동작 추가 (사진 등록)
      },
      child: const CircleAvatar(
        child: Icon(Icons.person),
        radius: 40.0,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: const ChildAppBar(title: "내 정보"),
        endDrawer: ChildDrawerMenu(),
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
                        MediaQuery
                            .of(context)
                            .size
                            .width, // 화면 가로 길이로 설정
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
                          child: const Text(
                            "아동",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            // style: theme.textTheme.headlineLarge,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0), // 왼쪽 패딩을 20.0으로 설정
                        child: profileImage, // 프로필 사진 위젯 추가
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                          padding: getPadding(
                            right: 190,
                            bottom: 33,
                          ),
                          child: FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("Users")
                                .doc(currentUser?.email)
                                .collection("userinfo")
                                .doc("userinfo")
                                .get(),
                            builder: (context, userInfoSnapshot) {
                              if (userInfoSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // userInfo가 로드 중인 경우 표시할 위젯
                                return const CircularProgressIndicator();
                              } else if (userInfoSnapshot.hasError) {
                                // 에러 발생 시 처리
                                return const Text("사용자 이름을 불러오는 중 오류가 발생했습니다.");
                              } else if (!userInfoSnapshot.hasData ||
                                  !userInfoSnapshot.data!.exists) {
                                // userInfo가 없거나 문서가 존재하지 않는 경우 처리
                                return const Text("사용자 이름에 해당하는 정보가 없습니다.");
                              } else {
                                // userInfo가 로드되고 문서가 존재하는 경우
                                Map<String, dynamic> userInfoData =
                                userInfoSnapshot.data!.data()
                                as Map<String, dynamic>;
                                String userNameFromUserInfo =
                                userInfoData["name"]; // userInfo에서 이름 필드를 가져옵니다.

                                return Text(userNameFromUserInfo);
                              }
                            },
                          ),
                      ),
                    )

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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PreviousReservation(),
                    ),
                  );
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        // side: BorderSide(color: Colors.red)
                      )),
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(MediaQuery
                        .of(context)
                        .size
                        .width - 32,
                        48), // 가로 길이를 화면 가로 길이 - 32로 설정
                  ),
                ),
                child: const Row(
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
              ),
              const Spacer(),
              const Text(
                "십시일반",
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
                child: const Text(
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
      padding: const EdgeInsets.symmetric(horizontal: 16), // 좌우 마진 추가
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(color: MyColor.DARK_YELLOW, width: 2.0),
          color: Colors.white,
        ),
        child: const Row(
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
          onPressed: () {},
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(color: Colors.red), // 스트로크 색상을 빨간색으로 변경
              ),
            ),
            fixedSize: MaterialStateProperty.all<Size>(
              Size(MediaQuery
                  .of(context)
                  .size
                  .width - 32,
                  48), // 가로 길이를 화면 가로 길이 - 32로 설정
            ),
          ),
          child: const Row(
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
        ),
      ],
    );
  }
}