import 'package:chipin/colors.dart';
import 'package:chipin/restaurant_main/RestaurantMain.dart';
import 'package:flutter/material.dart';
import 'package:chipin/base_appbar.dart';
import 'package:flutter/services.dart';
import 'restaurant_register_component.dart';
import 'package:chipin/base_button.dart';
import '../base_outline_input.dart';
import 'base_time_picker.dart';

class RestaurantRegister extends StatefulWidget {
  const RestaurantRegister({Key? key}) : super(key: key);

  @override
  State<RestaurantRegister> createState() => _RestaurantRegisterState();
}

class _RestaurantRegisterState extends State<RestaurantRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: '가게 정보 등록하기'),
      body: Container(
        color:MyColor.BACKGROUND,
        padding: EdgeInsets.symmetric(horizontal: 31,),
        child : SingleChildScrollView(
      child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              const RestaurantRegisterComponent(subject: Text('상호', style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)), form: TextField()),
              const SizedBox(height: 50),
              RestaurantRegisterComponent(subject:Text('유선전화', style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)), form: TextField(keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly])),
              const SizedBox(height: 50),
              Row(
                children: <Widget>[
                  Container(
                    width : 70,
                    child : Text('주소',
                        style: TextStyle(fontSize:16, fontFamily: "Mainfonts"))),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      children: [
                        RestaurantRegisterComponent(subject: Text('광역시/도'), form: TextField()),
                        RestaurantRegisterComponent(subject: Text('시/군/구'), form: TextField()),
                        RestaurantRegisterComponent(subject: Text('도로명'), form: TextField()),
                        RestaurantRegisterComponent(subject: Text('상세 주소'), form: TextField())
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: <Widget>[
                  Container(
                    width: 70,
                    child: Text(
                      '영업 시간',
                      style: TextStyle(fontSize: 16, fontFamily: "Mainfonts"),
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    flex:2,
                    child: Row(
                      children: <Widget>[
                        TimePickerExample(),
                        // BaseOutlineInput(),
                        // SizedBox(width: 10),
                        // BaseOutlineInput(),
                        SizedBox(width: 10),
                        Text(":" , style: TextStyle(fontSize: 16, fontFamily: "Mainfonts")),
                        SizedBox(width: 10),
                        // BaseOutlineInput(),
                        // SizedBox(width: 10),
                        // BaseOutlineInput()
                        TimePickerExample(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              RestaurantRegisterComponent(subject: Text('휴무일', style: TextStyle(fontFamily: "Mainfonts", fontSize: 16)), form: TextField()),
              SizedBox(height: 50),
              Row(
                children: <Widget>[
                  Text('사업자\n등록 번호',
                      style: TextStyle(fontSize:16, fontFamily: "Mainfonts")),
                  SizedBox(width: 130),
                  BaseButton(text: "파일 첨부", fontsize: 13)
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children : [BaseButton(text: "등록", fontsize: 16, onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const RestaurantMain())),)
                ]
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      )
    );
  }
}
