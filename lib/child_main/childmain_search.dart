import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../child_code_generate/code_generate_screen.dart';
import '../child_profile/profile_screen.dart';
import '../colors.dart';


class ChildMainSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomSearchContainer(),
        CustomCategoryChip(),
      ],
    );
  }
}

class CustomSearchContainer extends StatelessWidget {
  late bool isCardOK;
  String? userid = FirebaseAuth.instance.currentUser!.email;
  getUserInfo() async {
    var documentSnapshot = await FirebaseFirestore.instance.collection("Child").doc(userid).get();
    bool isCardOK = documentSnapshot["cardinfo"]["isCardAuthenticated"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getUserInfo(),
            builder: (context, snapshot) {
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ProfileScreen(isCardVerified: isCardOK))); }
                          , icon: Icon(Icons.person)),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
              );
            }
        )
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
