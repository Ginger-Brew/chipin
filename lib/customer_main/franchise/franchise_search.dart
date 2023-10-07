import 'package:chipin/child/screen/child_main/search_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

bool? idInReservation; // 사용자의 idInReservation 상태에 따라 설정
String searchContents = "";

class FranchiseSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomSearchContainer()
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
            CustomTextField(),
            IconButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchResult(searchContents : searchContents))); }
                , icon: const Icon(Icons.search)),
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
        onChanged: (contents) {
          searchContents = contents;
        },
        maxLines: 1,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(16),
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
        // if (data.containsKey('isUsed')) {
        //   return data['isUsed'] == false;
        // }
        return data['idInReservation'] == true;
      }
    }
    return false;
  });
}