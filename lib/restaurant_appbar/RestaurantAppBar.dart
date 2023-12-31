import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';

import '../restaurant_main/RestaurantMain.dart';

class RestaurantAppBar extends StatelessWidget implements PreferredSize{
  final String title;
  // final VoidCallback drawer;

  const RestaurantAppBar({Key? key, required this.title,}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return  PreferredSize(preferredSize: Size.fromHeight(44),
        child: AppBar(
          backgroundColor: MyColor.DARK_YELLOW,
          title:Text("십시일반", style: const TextStyle(fontSize:24, fontFamily: "Mainfonts",color: Colors.black)),
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.home), onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const RestaurantMain()), (route) => false);
          }),
          actions: [
            Builder(builder: (context) {
              return IconButton(icon: Icon(Icons.person), onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },);
            })],

        ));
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}