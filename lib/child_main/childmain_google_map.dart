import 'package:flutter/material.dart';


/// Google Map in the background
class CustomGoogleMap extends StatelessWidget {
  const CustomGoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      child: Center(child: Text("Google Map here")),
    );
  }
}