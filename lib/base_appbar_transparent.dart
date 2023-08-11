import 'package:flutter/material.dart';

class BaseAppBarTransparent extends StatelessWidget implements PreferredSize{
  const BaseAppBarTransparent({Key? key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return  PreferredSize(preferredSize: Size.fromHeight(44), child: AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
      actions: [IconButton(icon: Icon(Icons.menu_rounded), onPressed: null)],
    ));
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}