import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientYellowBtn extends StatelessWidget {
  final String imgPath;
  final String title;

  const ClientYellowBtn({Key? key,
    required this.imgPath,
    required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
      decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(15.0)
      ),
      child: Row(
        children: [
          Expanded(
            child: Image(
                width: 45.0,
                height: 45.0,
                image: AssetImage('assets/images/'+imgPath)  //  assets/images/receipt.png
            ),
            flex: 1,
          ),
          Expanded(
            child: Text(
                title,  //  영수증 인증하기
                style: TextStyle(
                    fontFamily: "Mainfonts",
                    fontSize: 20,
                    color: Colors.black)
            ),
          )
        ],
      ),
    );
  }

}