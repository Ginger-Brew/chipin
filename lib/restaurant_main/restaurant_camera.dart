import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';
import 'package:chipin/base_shadow.dart';

class CameraButton extends StatelessWidget {
  const CameraButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseShadow(container: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            foregroundColor: MyColor.HOVER),
        onPressed: () {},
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment : MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.camera_fill, color: MyColor.DARK_YELLOW,size:45)
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Row(
              mainAxisAlignment : MainAxisAlignment.center,
              children: [
                Text(
                  "QR 코드로 결제하기",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Mainfonts",
                      color: Colors.black),
                )
              ],
            )
          ],
        )));
  }

}