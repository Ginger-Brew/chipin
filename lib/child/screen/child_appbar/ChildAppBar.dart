import 'package:chipin/child/screen/child_main/ChildMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';

class ChildAppBar extends StatelessWidget implements PreferredSize {
  final String title;
  const ChildAppBar({Key? key, required this.title,}): super(key: key);


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return  PreferredSize(preferredSize: Size.fromHeight(44),
        child: AppBar(
          backgroundColor: MyColor.DARK_YELLOW,
          title:Text(title, style: const TextStyle(fontSize:24, fontFamily: "Mainfonts",color: Colors.black)),
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.home), onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const ChildMain()),(route) =>false);
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