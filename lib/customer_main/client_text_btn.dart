import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientTextBtn extends StatelessWidget {
  final String imgPath;
  final String title;
  const ClientTextBtn(
      {Key? key,
        required this.imgPath,
        required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Image(
                width: 20.0,
                height: 20.0,
                image: AssetImage("assets/images/"+imgPath) //assets/images/present.png
            ),
            Container(
              width: 10,
            ),
            Text(
                title,  // 이달의 후원달력
                style: TextStyle(
                    fontFamily: "Mainfonts",
                    fontSize: 20,
                    color: Colors.black)
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
          ],
        )
    );
  }
}