import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../model/model_child.dart';
import '../child_code_generate/code_generate_screen.dart';
import '../child_profile/profile_screen.dart';

bool idInReservation = true; // 사용자의 idInReservation 상태에 따라 설정

class ChildMainSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomSearchContainer(),
        buildReservationButton(),
      ],
    );
  }
}

class CustomSearchContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
      //adjust "40" according to the status bar size
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: <Widget>[
            SizedBox(width: 16),
            Icon(Icons.search),
            CustomTextField(),
            IconButton(
                onPressed: () {
                  Child child = Child();
                  bool isCardOK = child.getIsCardAuthenticated();

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(isCardVerified: isCardOK))); }
                , icon: Icon(Icons.person)),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          hintText: "가게 이름으로 검색하기",
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class CustomUserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
          color: Colors.grey[500], borderRadius: BorderRadius.circular(16)),
    );
  }
}
User? getUser() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final name = user.displayName;
    final email = user.email;
    final photoUrl = user.photoURL;
    final emailVerified = user.emailVerified;
    final uid = user.uid;
  }
  return user;
}
Future<bool> getIdInReservation(String email) async {
  final documentSnapshot = await FirebaseFirestore.instance.collection("Child").doc(email).get();

  if (documentSnapshot.exists) {
    final data = documentSnapshot.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('idInReservation')) {
      return data['idInReservation'] == true;
    }
  }

  return false; // 기본적으로 false로 설정 또는 사용자 데이터를 찾을 수 없는 경우 false로 설정
}
Widget buildReservationButton() {
  User? currentChild = getUser();

  if (currentChild != null) {
    String? email = currentChild.email;

    return FutureBuilder<bool>(
      future: getIdInReservation(email!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터를 아직 가져오는 중인 경우 로딩 표시나 기본값 반환 가능
          return CircularProgressIndicator(); // 예시로 로딩 인디케이터를 반환합니다.
        }

        if (snapshot.hasError || !snapshot.data!) {
          // 데이터를 가져오지 못하거나 idInReservation이 false인 경우
          return Container(); // 버튼을 숨기거나 다른 로직을 수행할 수 있습니다.
        }

        // idInReservation이 true인 경우 버튼을 반환
        return const CustomCategoryChip();
      },
    );
  } else {
    // 사용자가 로그인하지 않은 경우
    return Container();
  }
}
class CustomCategoryChip extends StatelessWidget {
  const CustomCategoryChip({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CodeGenerateScreen()));
        },
        child: Center(
            child: Card(
                color: MyColor.DARK_YELLOW,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4.0,
                child: Container(
                    width: 450,
                    height: 50,
                    child: Center(
                        child: Text("예약현황보기",
                            style: TextStyle(
                                fontFamily: "Mainfonts", fontSize: 15),
                            textAlign: TextAlign.center))))));
    ;
  }
}
