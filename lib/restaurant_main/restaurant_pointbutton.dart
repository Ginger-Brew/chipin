import 'package:chipin/restaurant_point_list/RestaurantEarnList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';
import 'package:chipin/base_shadow.dart';

class PointButton extends StatelessWidget {
  const PointButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseShadow(
        container: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                foregroundColor: MyColor.HOVER),
            onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => const RestaurantEarnList()));},
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset('assets/images/coins.png'),
                      flex: 2,
                    ),
                    Expanded(
                        flex: 7,
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "가게 잔여 포인트",
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              )
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "3500P",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontFamily: "Mainfonts"),
                              )
                            ],
                          )
                        ])),
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [Icon(Icons.arrow_forward_ios_rounded)],
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            )));
  }
}
