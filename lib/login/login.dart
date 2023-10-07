// 참고 https://cholol.tistory.com/572

import 'package:chipin/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'choice_role.dart';
import 'model/model_auth.dart';
import 'model/model_login.dart';

final TextEditingController _idController =
    TextEditingController(text: ""); //입력되는 값을 제어
final TextEditingController _passwordController = TextEditingController(text: "");

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    _idController.addListener(() { print("login화면");});
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
        create: (_) => LoginModel(),
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.only(top:screenHeight*0.2),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Image(
                          width: screenWidth * 0.3,
                          height: screenWidth * 0.3,
                          fit: BoxFit.contain,
                          image: AssetImage("assets/images/logo.png"))),
                  SizedBox(height: screenHeight*0.05),
                  IdInput(),
                  PasswordInput(),
                  LoginButton(),
                  SizedBox(height: screenHeight*0.05),
                  Align(
                    alignment: Alignment.center,
                    child: Row(children: [
                      Expanded(child: FindById()),
                      Expanded(child: RegisterButton())
                    ]),
                  )
                ],
              ),
            ),
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
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final login = Provider.of<LoginModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
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
    var screenWidth = MediaQuery.of(context).size.width;
    final login = Provider.of<LoginModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
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

class LoginButton extends StatefulWidget {
  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  User? getUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Name, email address, and profile photo URL
      final name = user.displayName;
      final email = user.email;
      final photoUrl = user.photoURL;

      // Check if user's email is verified
      final emailVerified = user.emailVerified;

      // The user's ID, unique to the Firebase project. Do NOT use this value to
      // authenticate with your backend server, if you have one. Use
      // User.getIdToken() instead.
      final uid = user.uid;
    }
    return user;
  }

  Future<int> isPresentRestaurantInfo() async {
    User? currentUser = getUser();
    if (currentUser != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot document =
          await firestore.collection("Restaurant").doc(currentUser.email).get();

      if (document.exists) {
        return 1;
      } else {
        return -1;
      }
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final authClient =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    final login = Provider.of<LoginModel>(context, listen: false);

    return Container(
      width: screenWidth * 0.8, // 화면 가로 크기의 반
      height: screenHeight * 0.08,
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
              final docRef = FirebaseFirestore.instance
                  .collection("Users")
                  .doc(login.id)
                  .collection("userinfo")
                  .doc("nowrole");
              docRef.get().then(
                (DocumentSnapshot doc) async {
                  final data = doc.data() as Map<String, dynamic>;
                  nowrole = data["nowrole"];
                  if (nowrole == "child") {
                    Navigator.pushReplacementNamed(context, '/childmain');
                  } else if (nowrole == "restaurant") {
                    int direnction = await isPresentRestaurantInfo();
                    debugPrint("debug + ${direnction}");

                    if (direnction == 1) {
                      Navigator.pushReplacementNamed(context, '/storemain');
                    } else {
                      Navigator.pushReplacementNamed(context, '/storeregister');
                    }
                  } else if (nowrole == "client") {
                    Navigator.pushReplacementNamed(context, '/clientmain');
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChoiceRole()));
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
