import 'package:chipin/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';
import 'package:chipin/login/login.dart';
class RestaurantDrawerMenu extends StatefulWidget {
  const RestaurantDrawerMenu({Key? key}) : super(key: key);

  @override
  State<RestaurantDrawerMenu> createState() => _RestaurantDrawerMenuState();
}

class _RestaurantDrawerMenuState extends State<RestaurantDrawerMenu> {
  String name = "";
  String email = "";


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

  Future<void> getUserInfo() async {
    User? currentUser = getUser();


    if (currentUser != null) {
      final db = FirebaseFirestore.instance.collection("Users").doc(
          currentUser.email).collection("userinfo").doc("userinfo");

      await db.get().then((DocumentSnapshot ds) {
        Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

        setState(() {
          name = data['name'];
          email = data['email'];

        });
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('로그인 정보가 유효하지 않습니다')));
    }
    debugPrint("namedebug : ${name}");
    debugPrint("emaildebug : ${email}");
    }

    Future<void> deleteUser() async{
    User? currentUser = getUser();
    await currentUser?.delete();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('회원 탈퇴 완료되었습니다')));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()), (route) => false);

    }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }


      @override
  Widget build(BuildContext context) {
        return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // 프로젝트에 assets 폴더 생성 후 이미지 2개 넣기
          // pubspec.yaml 파일에 assets 주석에 이미지 추가하기
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              // 현재 계정 이미지 set
              backgroundImage: AssetImage('assets/images/nobanner.png'),
              backgroundColor: Colors.white,
            ),
            accountName: Text(name, style: TextStyle(color: Colors.black),),
            accountEmail: Text(email, style: TextStyle(color: Colors.black)),
            // onDetailsPressed: () {
            //   print('arrow is clicked');
            // },
            decoration: BoxDecoration(
                color: MyColor.DARK_YELLOW,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0))),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.grey[850],
            ),
            title: Text('로그아웃'),
            onTap: () {
              print('Home is clicked');
            },
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          ),
          ListTile(
            leading: Icon(
              Icons.message,
              color: Colors.grey[850],
            ),
            title: Text('회원탈퇴'),
            onTap: () {
              deleteUser();
            },
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          ),

        ],
      ),
    );
  }
}

