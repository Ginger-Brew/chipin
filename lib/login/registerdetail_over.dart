import 'package:chipin/colors.dart';
import 'package:chipin/login/information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/model_auth.dart';
import 'model/model_register.dart';

const String role = "";
final userinfo = <String, dynamic>{
  "totalrole": <String, bool>{
    "child": false,
    "restaurant": false,
    "client": false
  },
  "name": "",
  "email": "",
  "id": ""
};

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // var checkOver = false;
  // var checkAgree = false;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
        create: (_) => RegisterModel(),
        child: Scaffold(
          appBar: AppBar(
            //backgroundColor: MyColor.DARK_YELLOW,
            title: Text("회원가입",
                style: const TextStyle(
                    fontSize: 24,
                    fontFamily: "Mainfonts",
                    color: Colors.black)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight*0.01,
                  ),
                  NameInput(),
                  EmailInput(),
                  PasswordInput(),
                  PasswordConfirmInput(),
                  IDInput(),
                  CheckOver(),
                  CheckAgree(),
                  SizedBox(
                    height: screenHeight*0.03,
                  ),
                  RegistButton(),
                  SizedBox(
                    height: screenHeight*0.03,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class CheckOver extends StatefulWidget {
  const CheckOver({Key? key}) : super(key: key);

  @override
  State<CheckOver> createState() => _CheckOverState();
}

class _CheckOverState extends State<CheckOver> {
  var checkOver = false;

  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Row(children: [
      Checkbox(
        value: checkOver,
        onChanged: (value) {
          setState(() {
            checkOver = value!;
            register.setCheckOver(value!);
          });
        },
      ),
      Text(
        '만 14세 이상입니다',
        style: TextStyle(fontSize: 13),
      )
    ]);
  }
}

class CheckAgree extends StatefulWidget {
  const CheckAgree({Key? key}) : super(key: key);

  @override
  State<CheckAgree> createState() => _CheckAgreeState();
}

class _CheckAgreeState extends State<CheckAgree> {
  var checkAgree = false;

  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Row(children: [
      Checkbox(
        value: checkAgree,
        onChanged: (value) {
          setState(() {
            checkAgree = value!;
            register.setCheckAgree(value!);
          });
        },
      ),
      TextButton(
        onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Information()));
      },
        child: Text('이용 약관 및 개인 정보 취급 방침에 동의합니다',
        style: TextStyle(fontSize: 13)),
      )
    ]);
  }
}

class IDInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('아이디', style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
        SizedBox(
          height: 10,
        ),
        TextField(
          onChanged: (id) {
            register.setId(id);
            userinfo["id"] = register.id;
          },
          decoration:
              InputDecoration(border: OutlineInputBorder(), isDense: true),
        ),
      ]),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('이메일', style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          TextField(
            onChanged: (email) {
              register.setEmail(email);
              userinfo["email"] = register.email;
            },
            keyboardType: TextInputType.emailAddress,
            decoration:
                InputDecoration(border: OutlineInputBorder(), isDense: true),
          ),
        ]));
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context);
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('비밀번호', style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          TextField(
            onChanged: (password) {
              register.setPassword(password);
            },
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              errorText: register.password != register.passwordConfirm
                  ? '비밀번호가 일치하지 않습니다'
                  : null,
            ),
          ),
        ]));
  }
}

class PasswordConfirmInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
              onChanged: (password) {
                register.setPasswordConfirm(password);
              },
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: '비밀번호 확인'))
        ]));
  }
}

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('이름', style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          TextField(
              onChanged: (name) {
                register.setName(name);
                userinfo["name"] = register.name;
              },
              decoration:
                  InputDecoration(border: OutlineInputBorder(), isDense: true)),
        ]));
  }
}

class RegistButton extends StatelessWidget {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final authClient =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    final register = Provider.of<RegisterModel>(context);

    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.07,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColor.DARK_YELLOW,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: ((register.checkOver && register.checkAgree) &&
                register.password != register.passwordConfirm)
            ? null
            : () async {
                await authClient
                    .registerWithEmail(register.email, register.password)
                    .then((registerStatus) async {
                  if (registerStatus == AuthStatus.registerSuccess) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text('회원가입 성공')),
                      );

                    debugPrint('${register.checkOver && register.checkAgree}');
                    final usercollection = FirebaseFirestore.instance
                        .collection("Users")
                        .doc(register.email)
                        .collection("userinfo");
                    usercollection.doc("userinfo").set(userinfo);
                    usercollection.doc("nowrole").set({'nowrole': ""});

                    Navigator.of(context).pushNamed('/login');
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text('회원가입 실패')),
                      );
                  }
                });
              },
        child: Text('가입하기',
            style: TextStyle(
                fontSize: 16,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
