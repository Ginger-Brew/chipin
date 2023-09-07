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

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RegisterModel(),
        child: Scaffold(
          appBar: BaseAppBar(title: '회원가입'),
          body: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 10)),
              IDInput(),
              PasswordInput(),
              PasswordConfirmInput(),
              NameInput(),
              EmailInput(),
              RegistButton()
            ],
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

              Navigator.pop(context);
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
