import 'dart:math';

import 'package:flutter/material.dart';

class Helper {
  /*
  * description: Change colors to material colors
  * input: Color
  * Output: material color
  */
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static String generateRandomString(int len) {
    var r = Random();
    const chars = '1234567890';
    String key= List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
    return "#$key";
  }
}
