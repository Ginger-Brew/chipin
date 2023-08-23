import 'package:flutter/material.dart';
import 'colors.dart';

class BaseAppBar extends StatelessWidget implements PreferredSize{
  final String title;

  const BaseAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return  PreferredSize(preferredSize: Size.fromHeight(44), child: AppBar(
      backgroundColor: MyColor.DARK_YELLOW,
      title:Text(title, style: const TextStyle(fontSize:24, fontFamily: "Mainfonts",color: Colors.black)),
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.home), onPressed: null),
      actions: [IconButton(icon: Icon(Icons.person), onPressed: null)],
    ));
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}