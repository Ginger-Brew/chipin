import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';

class ShadowButton extends StatelessWidget {
  const ShadowButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
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
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                foregroundColor: MyColor.HOVER),
            onPressed: () {},
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/ohyang_restaurant.png',
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Text(
                          "오양 칼국수",
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Mainfonts",
                              color: Colors.black),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "십시일반 포인트",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Mainfonts",
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "3500P",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Mainfonts",
                              color: MyColor.PRICE),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Icon(CupertinoIcons.placemark_fill,
                            color: Colors.black),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "충남 보령시 보령남로 125-7",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Mainfonts",
                              color: Colors.black),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(CupertinoIcons.clock_fill, color: Colors.black),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "매일 09:00 ~ 19:00",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Mainfonts",
                              color: Colors.black),
                        )
                      ],
                    ),
                  ],
                ))));
  }

}