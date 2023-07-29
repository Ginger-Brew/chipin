import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class BaseShadow extends StatelessWidget {
  final Widget container;
  const BaseShadow({Key? key, required this.container}) : super(key: key);

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
    child: container,);
  }
}

