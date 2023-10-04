import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';
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

class CustomSearchContainer extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late bool isCardAuthenticated = false;
  User? currentChild = getUser();
  Future<bool> checkIsAuthenticated() async {
    final isAuthenticatedQuery = await _firestore.collection('Child').doc(currentChild?.email).get();
    if (isAuthenticatedQuery.exists) {
      final AuthenticatedData = isAuthenticatedQuery.data();
      isCardAuthenticated = AuthenticatedData?['isCardAuthenticated'] ?? false;
      // print("가나다 $isCardAuthenticated");
      return isCardAuthenticated;
    }
    return false;
  }

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
            const SizedBox(width: 16),
            const Icon(Icons.search),
            CustomTextField(),
            IconButton(
                onPressed: () async {
                  bool isCardOK = await checkIsAuthenticated();

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(isCardVerified: isCardOK))); }
                , icon: const Icon(Icons.person)),
            const SizedBox(width: 16),
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
Stream<bool> getIdInReservationStream(String email) {
  return FirebaseFirestore.instance
      .collection("Child")
      .doc(email)
      .snapshots()
      .map((snapshot) {
    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null && data.containsKey('idInReservation')) {
        return data['idInReservation'] == true;
      }
    }
    return false;
  });
}
Widget buildReservationButton() {
  User? currentChild = getUser();

  if (currentChild != null) {
    String? email = currentChild.email;

    return StreamBuilder<bool>(
      stream: getIdInReservationStream(email!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터를 아직 가져오는 중인 경우 로딩 표시나 기본값 반환 가능
          return CircularProgressIndicator();
        }

        if (snapshot.hasError || !snapshot.data!) {
          // 데이터를 가져오지 못하거나 idInReservation이 false인 경우
          return Container();
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
                    child: const Center(
                        child: Text("예약현황보기",
                            style: TextStyle(
                                fontFamily: "Mainfonts", fontSize: 15),
                            textAlign: TextAlign.center))))));
    ;
  }
}
