import 'package:flutter/material.dart';

class PointHeader extends StatelessWidget {
  final String title;
  final String text;
  final Widget icon;
  const PointHeader({Key? key, required this.title, required this.text, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 17),
          )
        ]),
        SizedBox(height: 8,),
        Row(
          children: [
            icon,
            SizedBox(width: 10,),
            Text(
              text,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: "Mainfonts"),
            )
          ],
        )
      ],
    );
  }
}

