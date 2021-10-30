import 'package:flutter/material.dart';

class MyColors {
  static const Color blue = Color(0xff0666EB);
  static const Color lightBlue = Color(0xffE5EFFD);
  static const Color lightGrey = Color(0xffE1E1E1);
}
LinearGradient linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2B65EC),
      Color(0xFFADDFFF),
      Color(0xFFFFFFFF),
    ]
);