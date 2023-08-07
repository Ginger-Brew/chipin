import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';
import 'package:chipin/base_appbar.dart';
import 'restaurant_splitbutton.dart';
import 'restaurant_info.dart';
import 'restaurant_camera.dart';
import 'package:chipin/base_shadow.dart';
import 'restaurant_pointbutton.dart';
import 'package:chipin/restaurant_point_list/RestaurantEarnList.dart';

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
            child: SingleChildScrollView(
                child: Center(
                    child: Column(children: [
                      SizedBox(height: 40),
                      PointButton(),
                      SizedBox(height: 20),
                      Container(height: 388, child: ShadowButton()),
                      SizedBox(height: 20),
                      Container(height: 111, child: CameraButton()),
                      SizedBox(height: 20,),



                    ])))));
  }
}
