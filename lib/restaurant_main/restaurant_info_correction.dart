import 'package:chipin/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';
import 'package:chipin/base_shadow.dart';
import 'package:chipin/restaurant_correction/RestaurantInfoCorrection.dart';

class InfoCorrectionButton extends StatelessWidget {
  const InfoCorrectionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: EdgeInsets.fromLTRB(5, 0, 20, 0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color : Colors.black.withOpacity(0.15),
                blurRadius: 10,
                spreadRadius: 0.0,
                offset: const Offset(0,7)

            )
          ]
      ),
      child:  ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                foregroundColor: MyColor.HOVER),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RestaurantInfoCorrection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "가게 정보 수정",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "Mainfonts"),
                ),
                SizedBox(
                  height: 5,
                ),

                SizedBox(
                  height: 15,
                )
              ],
            )));
  }
}
