// 참고 https://cholol.tistory.com/572

import 'package:flutter/material.dart';

import '../child_main/ChildMain.dart';

final TextEditingController _emailController = TextEditingController(); //입력되는 값을 제어
final TextEditingController _passwordController = TextEditingController();

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/logo.png', // 로고 이미지 경로
            width: 304, // 로고 이미지 가로 크기
          ),
          SizedBox(height: 8),
          EmailInput(),
          SizedBox(height: 8),
          PasswordInput(),
          SizedBox(height: 16),
          SizedBox(height: 8),
          LoginButton(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Divider(
              thickness: 1,
            ),
          ),
          RegisterButton(),
        ],
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
          controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'email',
          helperText: '',
        ),
        validator: (String? value){
          if (value!.isEmpty) {// == null or isEmpty
            return '이메일을 입력해주세요.';
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
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        obscureText: true,
        controller: _passwordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'password',
          helperText: '',
        ),
        validator: (String? value){
          if (value!.isEmpty) {// == null or isEmpty
            return '비밀번호를 입력해주세요.';
          }
          return null;
        }
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 304, // 화면 가로 크기의 반
      height: 51,
      child : ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        // 로그인 버튼 클릭 시 넘어가는 화면
        // ************ 본인이 확인하고 싶은 화면 클래스 이름으로 수정해서 확인하기 *****************
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChildMain()));
        },
        child: Text('LOGIN'),
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
          'Regist by email',
          style: TextStyle(
            color: Colors.black87
          ),
        ));
  }
}