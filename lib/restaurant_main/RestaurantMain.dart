import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';
import 'package:chipin/base_appbar.dart';
import 'restaurant_splitbutton.dart';
import 'restaurant_info.dart';
import 'restaurant_camera.dart';
import 'package:chipin/base_shadow.dart';

class RestaurantMain extends StatefulWidget {
  const RestaurantMain({Key? key}) : super(key: key);

  @override
  State<RestaurantMain> createState() => _RestaurantMainState();
}

class _RestaurantMainState extends State<RestaurantMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: BaseAppBar(title: "십시일반"),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: SingleChildScrollView(
                child: Center(
                    child: Column(children: [
              BaseShadow(
                container: Column(
                  children: [
                    Container(
                        height: 50,
                        child: SplitButton(
                            subject: Text(
                              "가게 잔여 포인트",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            variance: Text("3500P",
                                style: TextStyle(
                                    fontFamily: "Mainfonts",
                                    fontSize: 20,
                                    color: Colors.black)),
                            topLeftRadius: 10,
                            topRightRadius: 10,
                            bottomLeftRadius: 0,
                            bottomRightRadius: 0,
                            onPressed: () { })),
                    Container(
                      height: 1,
                      width: double.maxFinite,
                      color: MyColor.DIVIDER,
                    ),
                    Container(
                        height: 50,
                        child: SplitButton(
                            subject: Text("현재까지 후원한 아이들",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black)),
                            variance: Text("10명",
                                style: TextStyle(
                                    fontFamily: "Mainfonts",
                                    fontSize: 20,
                                    color: Colors.black)),
                            topLeftRadius: 0,
                            topRightRadius: 0,
                            bottomLeftRadius: 10,
                            bottomRightRadius: 10,
                            onPressed: () {})),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(height: 388, child: ShadowButton()),
              SizedBox(height: 20),
              Container(height: 111, child: CameraButton()),
              SizedBox(
                height: 20,
              )
            ])))));
  }
}
