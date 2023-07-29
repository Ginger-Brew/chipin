import 'package:flutter/material.dart';
import 'colors.dart';

class BaseButton extends StatelessWidget {
  final String text;
  final double fontsize;
  final VoidCallback? onPressed;

  const BaseButton(
      {Key? key, required this.text, required this.fontsize, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: fontsize)),
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColor.DARK_YELLOW,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5))));
  }
}
