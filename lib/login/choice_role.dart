import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Text(
            "유형을 선택해주세요",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
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
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Image.asset('images/client.png'),
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "아동",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
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
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Image.asset('images/offer.png'),
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "가게",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
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
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Image.asset('images/offer.png'),
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "손님",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      if (role == "") {
                        _showDialog(context, "역할을 선택해주세요.");
                      }else {
                        Navigator.of(context).pushNamed(role);
                      }
                    },
                    child: Text(
                      '역할 선택',
                      style: TextStyle(color: Colors.black87),
                    ))
              ],
            ))
      ],
    );
  }
}

// API에 있는 showDialog 함수와 이름이 같아서 밑줄(_) 접두사(private 함수)
void _showDialog(BuildContext context, String text) {
  // 경고창을 보여주는 가장 흔한 방법.
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          content: Text(text)
        );
      }
  );
}