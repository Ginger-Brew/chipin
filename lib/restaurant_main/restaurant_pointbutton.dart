import 'package:chipin/restaurant_point_list/RestaurantEarnList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';
import 'package:chipin/base_shadow.dart';

class PointButton extends StatelessWidget {
  const PointButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
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
                      builder: (context) => const RestaurantEarnList()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "가게 잔여 포인트",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "Mainfonts"),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.asset('assets/images/coins.png'),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                        flex: 4,
                        child: Text(
                          "3500P",
                          style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontFamily: "Mainfonts"),
                        ))
                  ],
                ),
                SizedBox(
                  height: 15,
                )
              ],
            )));
  }
}
