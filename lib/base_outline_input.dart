import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseOutlineInput extends StatelessWidget {
  const BaseOutlineInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: TextField(
        style: TextStyle(fontSize: 16, height: 1, color: Colors.black),
        decoration: InputDecoration(border:OutlineInputBorder(),isDense: true),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center
    ));
  }
}
