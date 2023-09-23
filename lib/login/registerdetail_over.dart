import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../base_appbar.dart';
import 'model_auth.dart';
import 'model_register.dart';

const String role = "";
final userinfo = <String, dynamic>{
  "totalrole": <String, bool>{
    "child": false,
    "restaurant": false,
    "client": false
  },
  "name": "",
  "email": "",
  "id" : ""
};

class RegisterDetailOverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterDetailOverPageState();
}

class _RegisterDetailOverPageState extends State<RegisterDetailOverPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RegisterModel(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
            Expanded(
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child:Container(
                        margin:EdgeInsets.only(left: 50),
                        child:const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "회원가입",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              Text(
                                "만 14세 이상입니다.",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54),
                              )
                            ]),
                      )
                  ),
                  IDInput(),
                  PasswordInput(),
                  PasswordConfirmInput(),
                  NameInput(),
                  EmailInput(),
                  RegistButton()
                ],
              ),
            ),
          ),
        ));
  }
}

class IDInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(15),
      child: TextField(
        onChanged: (id) {
          register.setId(id);
          userinfo["id"] = register.id;
        },
        decoration: InputDecoration(
          labelText: 'id',
          helperText: '',
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(15),
      child: TextField(
        onChanged: (email) {
          register.setEmail(email);
          userinfo["email"] = register.email;
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'email',
          helperText: '',
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context);
    return Container(
      padding: EdgeInsets.all(15),
      child: TextField(
        onChanged: (password) {
          register.setPassword(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'password',
          helperText: '',
          errorText: register.password != register.passwordConfirm
              ? 'Password incorrect'
              : null,
        ),
      ),
    );
  }
}

class PasswordConfirmInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(15),
      child: TextField(
        onChanged: (password) {
          register.setPasswordConfirm(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'password confirm',
          helperText: '',
        ),
      ),
    );
  }
}

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(15),
      child: TextField(
        onChanged: (name) {
          register.setName(name);
          userinfo["name"] = register.name;
        },
        decoration: InputDecoration(
          labelText: 'name',
          helperText: '',
        ),
      ),
    );
  }
}

// class BdayInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final register = Provider.of<RegisterModel>(context, listen: false);
//     return Container(
//       padding: EdgeInsets.all(15),
//       child: TextField(
//         onChanged: (name) {
//           register.setName(name);
//           userinfo["bday"] = register.name;
//         },
//         decoration: InputDecoration(
//           labelText: 'name',
//           helperText: '',
//         ),
//       ),
//     );
//   }
// }

class RegistButton extends StatelessWidget {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final authClient =
    Provider.of<FirebaseAuthProvider>(context, listen: false);
    final register = Provider.of<RegisterModel>(context);

    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: (register.password != register.passwordConfirm)
            ? null
            : () async {
          await authClient
              .registerWithEmail(register.email, register.password)
              .then((registerStatus) async {
            if (registerStatus == AuthStatus.registerSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('Regist Success')),
                );
              final usercollection =
              FirebaseFirestore.instance.collection("Users").doc(register.email).collection("userinfo");
              usercollection.doc("userinfo").set(userinfo);
              usercollection.doc("nowrole").set({'nowrole' : ""});

              Navigator.of(context).pushNamed('/login');
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('Regist Fail')),
                );
            }
          });
        },
        child: Text('Regist'),
      ),
    );
  }
}
