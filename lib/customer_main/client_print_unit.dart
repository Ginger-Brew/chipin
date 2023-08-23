import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class ClientPrintUnit extends StatelessWidget{
  final String title;
  final String date;
  final String point;
  const ClientPrintUnit(
      {Key? key,
        required this.title,
        required this.date,
        required this.point}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                width: 300,
                child: Text(
                    title,
                    style: TextStyle(
                        fontFamily: "Mainfonts",
                        fontSize: 20,
                        color: Colors.black)
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: 300,
                child: Text(
                    date,
                    style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 12,
                        color: Colors.grey)
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
                point,
                style: TextStyle(
                    fontFamily: "Mainfonts",
                    fontSize: 25,
                    color: MyColor.ALERT)
            ),
          )
        ],
      )
    );
  }

}