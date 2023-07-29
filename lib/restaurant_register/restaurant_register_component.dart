import 'package:flutter/material.dart';

class RestaurantRegisterComponent extends StatelessWidget {

  final Widget subject;
  final Widget form;
  const RestaurantRegisterComponent({Key? key, required this.subject, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            width: 70,
            child: subject
        ),
            SizedBox(width: 30),
        Expanded(child: form),
      ],
    );
  }
}

