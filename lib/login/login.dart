// 참고 https://cholol.tistory.com/572

import 'package:chipin/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'choice_role.dart';
import 'model_auth.dart';
import 'model_login.dart';

final TextEditingController _idController =
    TextEditingController(); //입력되는 값을 제어
final TextEditingController _passwordController = TextEditingController();

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => LoginModel(),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "로그인",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.bold,
                    fontSize: 32),
              ),
              SizedBox(height: 19),
              IdInput(),
              PasswordInput(),
              LoginButton(),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Row(children: [
                  Expanded(child: FindById()),
                  Expanded(child: RegisterButton())
                ]),
              )
            ],
          ),
        ));
  }
}

/*
아이디 입력창
 */
class IdInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final login = Provider.of<LoginModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 46),
      child: TextFormField(
        controller: _idController,
        onChanged: (id) {
          login.setId(id);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: '아이디',
          helperText: '',
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            // == null or isEmpty
            return '아이디를 입력해주세요.';
          }
          return null;
        },
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final login = Provider.of<LoginModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 46),
      child: TextFormField(
          obscureText: true,
          controller: _passwordController,
          onChanged: (password) {
            login.setPassword(password);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            labelText: '비밀번호',
            helperText: '',
          ),
          validator: (String? value) {
            if (value!.isEmpty) {
              // == null or isEmpty
              return '비밀번호를 입력해주세요.';
            }
            return null;
          }),
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    final login = Provider.of<LoginModel>(context, listen: false);

    return Container(
      width: MediaQuery.of(context).size.width - 92, // 화면 가로 크기의 반
      height: 51,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColor.DARK_YELLOW,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () async {
          await authClient
              .loginWithEmail(login.id, login.password)
              .then((loginStatus) {
            if (loginStatus == AuthStatus.loginSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content:
                        Text('welcome! ' + authClient.user!.email! + ' ')));
              String nowrole = "";
              //var logger = Logger();
              final docRef = FirebaseFirestore.instance.collection("Users").doc(login.id).collection("userinfo").doc("nowrole");
              docRef.get().then(
                    (DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  nowrole = data["nowrole"];
                  if (nowrole == "child") {
                    Navigator.pushReplacementNamed(context, '/childmain');
                  } else if (nowrole == "restaurant") {
                    Navigator.pushReplacementNamed(context, '/storemain');
                  } else if (nowrole == "client") {
                    Navigator.pushReplacementNamed(context, '/clientmain');
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChoiceRole()));
                  }
                },
                onError: (e) => print("Error getting document: $e"),
              );

            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('login fail')));
            }
          });
        },
        child: Text(
          '로그인',
          style: TextStyle(fontFamily: "Pretendard", fontSize: 16),
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/register');
        },
        child: Text(
          '회원가입',
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Pretendard",
            fontSize: 14,
          ),
        ));
  }
}

class FindById extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/register');
        },
        child: Text(
          '비밀번호 찾기',
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Pretendard",
            fontSize: 14,
          ),
        ));
  }
}
