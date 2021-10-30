import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
        required this.onPressed,
        required this.text,
        required this.style,
        required this.width,
        required this.height,
        this.textStyle})
      : super(key: key);

  final double width;
  final double height;
  final VoidCallback onPressed;
  final String text;
  final ButtonStyle style;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
        style: style,
      ),
    );
  }
}
