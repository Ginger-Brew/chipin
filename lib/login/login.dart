// 참고 https://cholol.tistory.com/572

import 'package:chipin/colors.dart';
import 'package:flutter/material.dart';
import 'choice_role.dart';

final TextEditingController _emailController = TextEditingController(); //입력되는 값을 제어
final TextEditingController _passwordController = TextEditingController();

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("로그인",style: TextStyle(color:Colors.black, fontFamily:"Pretendard",fontWeight:FontWeight.bold,fontSize: 32),),
          SizedBox(height: 19),
          IdInput(),
          PasswordInput(),
          LoginButton(),
          SizedBox(height: 16),
          Align(alignment: Alignment.center,
          child: Row(children: [Expanded(child:FindById()),Expanded(child:RegisterButton() )]),)


        ],
      ),
    );
  }
}

class IdInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 46),
      child: TextFormField(
          controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: '아이디',
          helperText: '',
        ),
        validator: (String? value){
          if (value!.isEmpty) {// == null or isEmpty
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 46),
      child: TextFormField(
        obscureText: true,
        controller: _passwordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: '비밀번호',
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
      width: MediaQuery.of(context).size.width -92, // 화면 가로 크기의 반
      height: 51,
      child : ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColor.DARK_YELLOW,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        // 로그인 버튼 클릭 시 넘어가는 화면
        // ************ 본인이 확인하고 싶은 화면 클래스 이름으로 수정해서 확인하기 *****************
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChoiceRole()));
        },
        child: Text('로그인',style: TextStyle(fontFamily: "Pretendard",fontSize: 16),),
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