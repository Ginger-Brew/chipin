import 'package:chipin/base_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/model_child.dart';

class ChoiceRole extends StatefulWidget {
  const ChoiceRole({super.key});

  @override
  _ChoiceRoleState createState() => _ChoiceRoleState();
}

class _ChoiceRoleState extends State<ChoiceRole> {
  String role = "";
  bool _childIsPressed = false;
  bool _storeIsPressed = false;
  bool _clientIsPressed = false;

  void _childToggleButton() {
    setState(() {
      _childIsPressed = !_childIsPressed;
      _storeIsPressed = false;
      _clientIsPressed = false;
      role = "/childmain";
    });
  }

  void _storeToggleButton() {
    setState(() {
      _storeIsPressed = !_storeIsPressed;
      _childIsPressed = false;
      _clientIsPressed = false;
      role = "/storemain";
    });
  }

  void _clientToggleButton() {
    setState(() {
      _clientIsPressed = !_clientIsPressed;
      _childIsPressed = false;
      _storeIsPressed = false;
      role = "/clientmain";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BaseAppBar(title: "소속 선택"),
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: _childToggleButton,
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                    if (_childIsPressed) {
                      return Colors.amber; // 선택시
                    }
                    return Colors.white; // 그 외에는 흰색
                  }),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: 50,
                        height: 50,
                        child: Image.asset('assets/images/child_role.png'),
                      ),
                      const Text(
                        "아동",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Pretendard"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: _storeToggleButton,
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                    if (_storeIsPressed) {
                      return Colors.amber; // 선택시
                    }
                    return Colors.white; // 그 외에는 흰색
                  }),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: 50,
                        height: 50,
                        child: Image.asset('assets/images/restaurant_role.png'),
                      ),
                      const Text(
                        "가게",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Pretendard"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: _clientToggleButton,
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                    if (_clientIsPressed) {
                      return Colors.amber; // 선택시
                    }
                    return Colors.white; // 그 외에는 흰색
                  }),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: 50,
                        height: 50,
                        child: Image.asset('assets/images/customer_role.png'),
                      ),
                      const Text(
                        "손님",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Pretendard"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
                onPressed: () async {
                  if (role == "") {
                    _showDialog(context, "역할을 선택해주세요.");
                  } else {
                    String? userid = FirebaseAuth.instance.currentUser!.email;
                    Map<String, bool> updaterole = {
                      "child": false,
                      "restaurant": false,
                      "client": false
                    };
                    String nowrole = "";
                    if (role == "/childmain") {
                      updaterole["child"] = true;
                      nowrole = "child";

                      /// Child 데이터 초기화
                      Child childuser = Child();

                      await FirebaseFirestore.instance.collection("Child").doc(userid).set(childuser.toJson());
                    } else if (role == "/storemain") {
                      updaterole["restaurant"] = true;
                      nowrole = "restaurant";
                      await FirebaseFirestore.instance.collection("Restaurant").doc(userid).set({});
                    } else if (role == "/clientmain") {
                      updaterole["client"] = true;
                      nowrole = "client";
                      await FirebaseFirestore.instance.collection("Client").doc(userid).set({});
                    }

                    await FirebaseFirestore.instance.collection("Users").doc(userid).collection("userinfo").doc("userinfo").update({'totalrole' : updaterole});
                    await FirebaseFirestore.instance.collection("Users").doc(userid).collection("userinfo").doc("nowrole").set({'nowrole' : nowrole});
                    Navigator.of(context).pushNamed(role);
                  }
                },
                child: const Text(
                  '역할 선택',
                  style: TextStyle(color: Colors.black87),
                )),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}

// API에 있는 showDialog 함수와 이름이 같아서 밑줄(_) 접두사(private 함수)
void _showDialog(BuildContext context, String text) {
  // 경고창을 보여주는 가장 흔한 방법.
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(content: Text(text,
            style: TextStyle(fontFamily: "Mainfonts", fontSize: 15), textAlign: TextAlign.center));
      });
}