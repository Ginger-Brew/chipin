import 'package:chipin/child/screen/child_appbar/ChildAppBar.dart';
import 'package:chipin/child/screen/child_authentication/authentication_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../core/utils/size_utils.dart';
import '../child_appbar/ChildDrawerMenu.dart';
import '../child_previous_reservation/previous_reservation.dart';

User? getUser() {
  final user = FirebaseAuth.instance.currentUser;
  return user;
}

class ProfileScreen extends StatelessWidget {
  final bool isCardVerified; // 복지카드 인증 여부

  const ProfileScreen({super.key, required this.isCardVerified});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    var screenWidth = mediaQueryData.size.width;
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
              radius: 40.0,
              child: Icon(Icons.person),
            ),
          );
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: const ChildAppBar(title: "내 정보"),
        endDrawer: const ChildDrawerMenu(),
        body: SizedBox(
          //width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                            width: screenWidth * 0.2,
                            height: screenWidth * 0.2,
                            child: profileImage),
                        Expanded(
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
                                  String userNameFromUserInfo = userInfoData[
                                      "name"]; // userInfo에서 이름 필드를 가져옵니다.
                                  String userEmailFromUserInfo = userInfoData[
                                      "email"]; // userInfo에서 이메일 필드를 가져옵니다.

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userNameFromUserInfo,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        userEmailFromUserInfo,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ))
                      ]),
                ),
                Expanded(
                    child: Column(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isCardVerified
                          ? const VerifiedCardWidget()
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
                        Size(MediaQuery.of(context).size.width - 32,
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
                ]))
              ])),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: const Column(
                  children: [
                    Text(
                      "십시일반",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      // style: theme.textTheme.labelLarge!.copyWith(
                      //   decoration: TextDecoration.underline,
                      // ),
                    ),
                    Text(
                      "version: 1.0.0",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      // style: CustomTextStyles.bodySmallInterGray600,
                    ),
                  ],
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
  const VerifiedCardWidget({super.key});

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
  User? currentUser = getUser();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("Child")
              .doc(currentUser?.email)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(), // 데이터를 기다리는 동안 로딩 표시
              );
            } else if (snapshot.hasError) {
              return Text('Error : ${snapshot.error}');
            } else if (snapshot.data != null && snapshot.data!.exists) {
              return const Text('카드 인증 확인 요청 중입니다...');
            } else {
              return ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthenticationScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(
                          color: Colors.red), // 스트로크 색상을 빨간색으로 변경
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(MediaQuery.of(context).size.width - 32,
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
              );
            }
          },
        )
      ],
    );
  }
}
