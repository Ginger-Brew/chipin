import 'package:chipin/colors.dart';
import 'package:flutter/material.dart';

class SplitButton extends StatelessWidget {
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final VoidCallback onPressed;
  final Widget subject;
  final Widget variance;

  const SplitButton({
    Key? key,
    required this.subject,
    required this.topLeftRadius,
    required this.topRightRadius,
    required this.bottomLeftRadius,
    required this.bottomRightRadius,
    required this.onPressed,
    required this.variance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeftRadius),
        topRight: Radius.circular(topRightRadius),
        bottomLeft: Radius.circular(bottomLeftRadius),
        bottomRight: Radius.circular(bottomRightRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Expanded(
              child: Align(
                child: subject,
                alignment: Alignment.centerLeft,
              ),
              flex: 7,
            ),
            Expanded(
              child: Align(
                child: variance,
                alignment: Alignment.centerRight,
              ),
              flex: 3,
            ),
            Expanded(
              child: Align(
                child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
                alignment: Alignment.centerRight,
              ),
              flex: 1,
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: MyColor.HOVER,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }
}
