import 'package:flutter/material.dart';

class SelectedBottomSheet extends StatefulWidget {
  const SelectedBottomSheet({super.key});
  @override
  State<SelectedBottomSheet> createState() => _SelectedBottomSheetState();
}

class _SelectedBottomSheetState extends State<SelectedBottomSheet> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          width: 200,
          height: 200,
          color: Colors.red,
        )
      ])
    );
  }
}
